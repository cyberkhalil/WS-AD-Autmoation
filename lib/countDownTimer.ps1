# Interface Definition
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr,0)

# Main Form Definition
$MainForm = New-Object System.Windows.Forms.Form
$MainForm.ClientSize = New-Object System.Drawing.Size (200,100)
$MainForm.MaximumSize = New-Object System.Drawing.Size (200,100)
$MainForm.MinimumSize = New-Object System.Drawing.Size (200,100)
$MainForm.MaximizeBox = $false
$MainForm.MinimizeBox = $false
$MainForm.StartPosition = "CenterScreen"
$MainForm.Text = "The Final Countdown"

# TimeRemaining Label
$TimeRemaining_Label = New-Object System.Windows.Forms.Label
$TimeRemaining_Label.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$TimeRemaining_Label.Location = New-Object System.Drawing.Point (10,10)
$TimeRemaining_Label.Size = New-Object System.Drawing.Size (120,80)
$TimeRemaining_Label.Font = "Segoe UI,10"
$TimeRemaining_Label.ForeColor = "#000000"
$TimeRemaining_Label.Text = "Time remaining :"

# Countdown
$Countdown_Label = New-Object System.Windows.Forms.Label
$Countdown_Label.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$Countdown_Label.Location = New-Object System.Drawing.Point (130,10)
$Countdown_Label.Size = New-Object System.Drawing.Size (25,80)
$Countdown_Label.Font = "Segoe UI,10"
$Countdown_Label.ForeColor = "#FF0000"

# Countdown starts at 10 secondes
$Countdown_Label.Text = "10"

# Countdown is decremented every seconde using a timer
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.add_Tick({ CountDown })
$timer.Start()

# Assign Button and Countdown to Page
$MainForm.Controls.Add($TimeRemaining_Label)
$MainForm.Controls.Add($Countdown_Label)

function Main {
  param(
    [string]$Title = "abc"
  )
  [System.Windows.Forms.Application]::EnableVisualStyles()
  [System.Windows.Forms.Application]::Run($MainForm)
}

function CountDown {
  $Countdown_Label.Text -= 1
  if ($Countdown_Label.Text -eq 0) {
    $timer.Stop()
    Action_After_End
  }
}

function Action_After_End {
  [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.MessageBox]::Show("Countdown ended","Info")
  $MainForm.close()
}


Main
