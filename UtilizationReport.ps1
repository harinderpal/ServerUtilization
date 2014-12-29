############################################################################
##                                                                        ##
##  SCRIPT.........:  Server_online.ps1                                   ##
##  AUTHOR.........:  Harinderpal Singh                                   ##
##  LINK...........:                                                      ##
##  VERSION........:  1.0                                                 ##
##  DATE...........:  29/12/2014                                          ##
##  DESCRIPTION....:  This script collects Server Information and         ##
##                    displays the results on the screen.                 ##
##                                                                        ##
##                                                                        ##
############################################################################



    $server = read-host -prompt "Enter Server name:"

    $Form = New-Object system.Windows.Forms.Form # form libraries
    $Form.Text = "Sample Form" # form title
    $Font = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Italic) # creating fonts 
    # Font styles are: Regular, Bold, Italic, Underline, Strikeout
    $Form.Font = $Font # applying the fonts formatting to form
    $Label = New-Object System.Windows.Forms.Label # creating variable label libraries
    $Label.Text = "Loading." # Adding text to label
    $Label.AutoSize = $True
    $Label.BackColor = "Transparent" 
    $Form.Width = 500 # whole form width
    $Form.Height = 700 # whole form hieght
       
    $results = Get-WMIObject -query "select StatusCode from Win32_PingStatus where Address = '$server'"

    $serverLogOnMode = $farmserver.LogOnMode
        
    if ($results.statuscode -eq 0) {
          		#
    			# Get Uptime
    			#
    			$os = gwmi Win32_OperatingSystem -computerName $server
    			$lastbootuptime = $os.ConvertToDateTime($os.LastBootUpTime)
    			$starttime = $OS.converttodatetime($OS.LastBootUpTime)
    			$uptime1 = New-TimeSpan (get-date $Starttime)
    			#$uptime_string = [string]$uptime.days + " Days " + $uptime.hours + "h " + $uptime.minutes + "m " + $uptime.seconds + "s"
    			$Uptime = [string]$uptime1.days + "d " + $uptime1.hours + "h " + $uptime1.minutes + "m " + $uptime1.seconds + "s"
    			
    		
    			#
    			# CPU and RAM
    			#
    			
    			$SystemInfo = Get-WmiObject -Class Win32_OperatingSystem -computername $server | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory 
                $Label.Text = "Loading.." # Adding text to label
     
    			 #Retrieving the total physical memory and free memory 
    			 
    			$TotalRAM = $SystemInfo.TotalVisibleMemorySize/1MB 
    			 
    			$FreeRAM = $SystemInfo.FreePhysicalMemory/1MB 
    			 
    			$UsedRAM = $TotalRAM - $FreeRAM 
    			 
    			$RAM = [Math]::Round(($UsedRAM / $TotalRAM) * 100 ,2)
    			 
    			#Calculating the memory used and rounding it to 2 significant figures 
    			 
    			$CPU1 = Get-WmiObject win32_processor -computername $server  | Measure-Object -property LoadPercentage -Average | Select Average     
    			 
    			#Get CPU load of machine 
    			 
    			$CPU=$CPU1.average
                
                
                #Calculation logical disk
                $logicalDisk = gwmi -query "select * from Win32_LogicalDisk where DriveType=3" -computername $server | select Name, FreeSpace, size
                $Label.Text = "Loading..." # Adding text to label

    			# Lets throw them into an object for outputting
             
                $k=20;
                $member = @("Server","Uptime","RAM","CPU")
                $member1 = @($server,$Uptime,$RAM,$CPU)
                $label = @(0..15)
                
                $Label[1] = New-Object System.Windows.Forms.Label # creating variable label libraries
                $label[1].Location = New-Object System.Drawing.Size(20,20) # Label Location
                $Label[1].Text = "Server :  $server"  # Adding text to label
                $Label[1].AutoSize = $True
                $Label[2] = New-Object System.Windows.Forms.Label # creating variable label libraries
                $label[2].Location = New-Object System.Drawing.Size(20,60) # Label Location
                $Label[2].Text = "Uptime : $Uptime"  # Adding text to label
                $Label[2].AutoSize = $True
                $Label[3] = New-Object System.Windows.Forms.Label # creating variable label libraries
                $label[3].Location = New-Object System.Drawing.Size(20,100) # Label Location
                $Label[3].Text = "RAM : $RAM%"  # Adding text to label
                $Label[3].AutoSize = $True
                $Label[4] = New-Object System.Windows.Forms.Label # creating variable label libraries
                $label[4].Location = New-Object System.Drawing.Size(20,140) # Label Location
                $Label[4].Text = "CPU : $CPU%"  # Adding text to label
                $Label[4].AutoSize = $True
               
                $i=5
                $k=180
    			                
                Foreach($log in $logicaldisk){
                    $s = [math]::round((($log.size/1024)/1024)/1024, 2)
                    $f = [math]::round((($log.FreeSpace/1024)/1024)/1024, 2)
                    $l = $log.name 
                    $Label[$i] = New-Object System.Windows.Forms.Label # creating variable label libraries
                    $label[$i].Location = New-Object System.Drawing.Size(20,$k) # Label Location
                    $Label[$i].Text = "Drive Name :  $l"  # Adding text to label
                    $Label[$i].AutoSize = $True
                    $Label[$i+1] = New-Object System.Windows.Forms.Label # creating variable label libraries
                    $label[$i+1].Location = New-Object System.Drawing.Size(80,($k+40)) # Label Location
                    $Label[$i+1].Text = "Size : $s GB"  # Adding text to label
                    $Label[$i+1].AutoSize = $True
                    $Label[$i+2] = New-Object System.Windows.Forms.Label # creating variable label libraries
                    $label[$i+2].Location = New-Object System.Drawing.Size(80,($k+80)) # Label Location
                    $Label[$i+2].Text = "Drive Free Space :  $f GB"  # Adding text to label
                    $Label[$i+2].AutoSize = $True
                    $i += 3
                    $k = $k + 120
                }
                For($j=1;$j -le 15;$j++){
                    $Form.Controls.Add($Label[$j]) # linking with label and form
                    }
                
             } else {
                # SERVER OFFLINE
                
                $Label = New-Object System.Windows.Forms.Label # creating variable label libraries
                $label.Location = New-Object System.Drawing.Size(20,20) # Label Location
                $Label.Text = "Server is offline"  # Adding text to label
                $Label.AutoSize = $True  
                $From.Controls.Add($Label)
            }
     
  	
 [void] $Form.ShowDialog()