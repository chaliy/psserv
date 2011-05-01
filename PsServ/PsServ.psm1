function Start-Serv {
[CmdletBinding()]
Param(	
	$URL = "http://+:8008/"
)
	#netsh http add urlacl http://+:8008/ user=Everyone listen=true	
	
	if (![Net.HttpListener]::IsSupported)
    {
        Write-Error "Connot start HTTP server because HttpListener is not supported on this platform."
        return
    }
    $Listener = (New-Object Net.HttpListener)    
    $Listener.Prefixes.Add($URL)
    $Listener.Start()
		
	$Listener.BeginGetContext([AsyncCallback]{
        Param($ar)
        Try {		
	        # Get the context
	        $context = $Listener.EndGetContext($ar)
	        # listen for the next request
	        #$Listener.BeginGetContext(GetContextCallback, null);
	        # get the request                        
	        $response = context.Response
	        $response.ContentType = "text/html"
	        #response.ContentLength64 = buffer.Length;
	        $response.StatusCode = 200;
			$writer = New-Object IO.StreamWriter($response.OutputStream)
			$writer.Write("Hello!")
			$writer.Flush()        
	        $response.OutputStream.Close()
		}
		Catch {
			Write-Host $_
		}
    }, $null)
	
	Read-Host "Yoy!"
    $Listener.Stop()

	
<#
.Synopsis
    Starts HTTP Server in current folder
.Description     
.Parameter [TBD]
    [TBD]
.Example
    Start-Serv

    Description
    -----------
    Starts HTTP Server in current folder

#>
}

Export-ModuleMember Start-Serv
