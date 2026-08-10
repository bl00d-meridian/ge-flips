param([string]$OutDir = "$PSScriptRoot\out")
# Beacon report listener for the headless-Edge probe suite — see PROBE.md.
# Raw TcpListener on purpose: HttpListener needs URL ACLs for non-admin users;
# a plain socket on 127.0.0.1 does not.
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 8347)
try { $listener.Start() } catch { Write-Output "listener FAILED to bind 127.0.0.1:8347 - $_"; exit 1 }
$deadline = (Get-Date).AddSeconds(150)
try {
  while ((Get-Date) -lt $deadline) {
    if (-not $listener.Pending()) { Start-Sleep -Milliseconds 200; continue }
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $stream.ReadTimeout = 8000
    $ms = New-Object System.IO.MemoryStream
    $buf = New-Object byte[] 65536
    $raw = ""
    $bodyLen = -1
    $headerEnd = -1
    $t0 = Get-Date
    while (((Get-Date) - $t0).TotalSeconds -lt 10) {
      try { $n = $stream.Read($buf, 0, $buf.Length) } catch { break }
      if ($n -le 0) { break }
      $ms.Write($buf, 0, $n)
      $raw = [System.Text.Encoding]::UTF8.GetString($ms.ToArray())
      if ($headerEnd -lt 0) {
        $headerEnd = $raw.IndexOf("`r`n`r`n")
        if ($headerEnd -ge 0 -and $raw -match "(?im)^Content-Length:\s*(\d+)") { $bodyLen = [int]$Matches[1] }
      }
      if ($headerEnd -ge 0) {
        $have = [System.Text.Encoding]::UTF8.GetByteCount($raw.Substring($headerEnd + 4))
        if ($bodyLen -ge 0 -and $have -ge $bodyLen) { break }
        if ($bodyLen -lt 0 -and -not $stream.DataAvailable) { break }
      }
    }
    $body = if ($headerEnd -ge 0) { $raw.Substring($headerEnd + 4) } else { $raw }
    $resp = [System.Text.Encoding]::ASCII.GetBytes("HTTP/1.1 204 No Content`r`nAccess-Control-Allow-Origin: *`r`nConnection: close`r`n`r`n")
    try { $stream.Write($resp, 0, $resp.Length); $stream.Flush() } catch {}
    $client.Close()
    if ($body -match "PROBE") {
      [System.IO.File]::WriteAllText("$OutDir\probe-report.txt", $body, (New-Object System.Text.UTF8Encoding($false)))
      break
    }
  }
} finally { $listener.Stop() }
Write-Output "listener done"
