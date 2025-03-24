taskkill /f /im explorer.exe

# Carica le assembly necessarie
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crea un timer per aggiornare l'effetto glitch ogni 15 millisecondi
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 15

# Funzione per creare un form per ogni schermo
function Create-GlitchForm {
    param (
        [System.Windows.Forms.Screen]$screen
    )

    # Crea il form full-screen per lo schermo specificato
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Glitch"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
    $form.TopMost = $true
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
    $form.Location = $screen.Bounds.Location
    $form.Size = $screen.Bounds.Size
    $form.BackColor = [System.Drawing.Color]::Black

    # Evento Tick del timer: disegna delle forme casuali
    $timer.Add_Tick({
        # Ottieni il contesto grafico per disegnare sul form
        $graphics = $form.CreateGraphics()
    })

    # Assicurati che il timer si fermi quando il form viene chiuso
    $form.Add_FormClosing({ $timer.Stop() })

    # Avvia il timer
    $timer.Start()

    # Avvia il form (modal)
    $form.Show()
}

# Ottieni tutti gli schermi collegati
$screens = [System.Windows.Forms.Screen]::AllScreens

# Crea un form per ogni schermo
foreach ($screen in $screens) {
    Create-GlitchForm -screen $screen
}

# Mantieni il processo in esecuzione finché ci sono form aperti
[System.Windows.Forms.Application]::Run()