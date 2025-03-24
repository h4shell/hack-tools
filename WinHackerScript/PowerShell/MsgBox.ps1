# Add-Type -AssemblyName System.Windows.Forms
# [System.Windows.Forms.MessageBox]::Show("prova", "prova", [System.Windows.Forms.MessageBoxButtons]::OK, "warning")

Add-Type -AssemblyName System.Windows.Forms
function Show-MessageBox {
    param (
        [string]$message,
        [string]$title,
        [System.Windows.Forms.MessageBoxIcon]$icon = [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, $icon)
}
$message = Read-Host "Inserisci il messaggio da mostrare"
$iconOptions = @(
    [System.Windows.Forms.MessageBoxIcon]::None,
    [System.Windows.Forms.MessageBoxIcon]::Error,
    [System.Windows.Forms.MessageBoxIcon]::Question,
    [System.Windows.Forms.MessageBoxIcon]::Warning,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
$iconNames = @("None", "Error", "Question", "Warning", "Information")
$iconChoice = $null
while ($iconChoice -eq $null) {
    $iconChoice = $null
    for ($i = 0; $i -lt $iconNames.Length; $i++) {
        Write-Host "$($i + 1): $($iconNames[$i])"
    }   
    $iconInput = Read-Host "Scegli l'icona (1-$($iconNames.Length)) [default: 4]"
    if ([string]::IsNullOrWhiteSpace($iconInput)) {
        $iconChoice = [System.Windows.Forms.MessageBoxIcon]::Warning
    } elseif ($iconInput -match '^\d+$' -and [int]$iconInput -ge 1 -and [int]$iconInput -le $iconNames.Length) {
        $iconChoice = $iconOptions[$iconInput - 1]
    } else {
        Write-Host "Opzione non valida. Riprova."
        $iconChoice = $null
    }
}
Show-MessageBox -message $message -title "HaCkeR Message" -icon $iconChoice