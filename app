<!DOCTYPE html>
<html lang="uz">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UC TERMINAL | Rasmiy</title>
    <style>
        body { margin: 0; background: #0c0c0d; color: white; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .app-card { width: 90%; max-width: 360px; background: #161618; padding: 25px; border-radius: 30px; border: 1px solid #282828; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.6); }
        
        .balance-section { background: #1f1f21; padding: 20px; border-radius: 20px; margin-bottom: 25px; border-bottom: 3px solid #f39c12; }
        .bal-title { font-size: 13px; color: #888; letter-spacing: 1px; }
        .bal-amount { font-size: 42px; font-weight: 900; color: #f39c12; margin: 5px 0; }

        .wheel-area { position: relative; width: 240px; height: 240px; margin: 0 auto 25px auto; }
        #wheel-img { width: 100%; height: 100%; border-radius: 50%; border: 8px solid #252525; transition: transform 4s cubic-bezier(0.15, 0, 0.15, 1);
            background: conic-gradient(#e74c3c 0% 16%, #3498db 16% 33%, #f1c40f 33% 50%, #2ecc71 50% 66%, #9b59b6 66% 83%, #e67e22 83% 100%);
        }
        .pointer-arrow { position: absolute; top: -15px; left: 50%; transform: translateX(-50%); width: 0; height: 0; border-left: 15px solid transparent; border-right: 15px solid transparent; border-top: 25px solid #fff; z-index: 10; filter: drop-shadow(0 2px 5px rgba(0,0,0,0.5)); }

        .btn { display: block; width: 100%; padding: 16px; margin: 12px 0; border-radius: 15px; border: none; font-weight: 800; font-size: 16px; cursor: pointer; transition: 0.2s; }
        .btn-main { background: #ffffff; color: #000; box-shadow: 0 4px 15px rgba(255,255,255,0.2); }
        .btn-main:active { transform: scale(0.96); }
        .btn-withdraw { background: #27ae60; color: white; }
        .btn-promo { background: transparent; border: 1px dashed #f39c12; color: #f39c12; font-size: 14px; }
        
        #status-text { height: 24px; color: #f1c40f; font-weight: 600; margin-top: 10px; }
        .timer-text { font-size: 13px; color: #ff4757; margin-top: 5px; font-weight: bold; }
    </style>
</head>
<body>

<div class="app-card">
    <h2 style="margin-top: 0; letter-spacing: 2px; color: #eee;">UC TERMINAL</h2>
    
    <div class="balance-section">
        <div class="bal-title">HISOBINGIZDA</div>
        <div class="bal-amount"><span id="user-bal">0</span> UC</div>
        <div style="font-size: 10px; color: #555;">MINIMAL CHIQARISH: 360 UC</div>
    </div>

    <div class="wheel-area">
        <div class="pointer-arrow"></div>
        <div id="wheel-img"></div>
    </div>

    <div id="status-text"></div>
    
    <button class="btn btn-main" id="spin-action" onclick="spinNow()">AYLANTIRISH (3/3)</button>
    <button class="btn btn-withdraw" onclick="cashOut()">YECHIB OLISH</button>
    <button class="btn btn-promo" onclick="usePromo()">PROMOKOD</button>
</div>

<script>
    let bal = parseInt(localStorage.getItem('pubg_bal')) || 0;
    let tries = parseInt(localStorage.getItem('pubg_tries')) || 3;
    let rotation = 0;

    function refresh() {
        document.getElementById('user-bal').innerText = bal;
        document.getElementById('spin-action').innerText = `AYLANTIRISH (${tries}/3)`;
        if(tries <= 0) {
            document.getElementById('spin-action').disabled = true;
            document.getElementById('status-text').innerHTML = "<span class='timer-text'>Vaqt tugadi! Ertaga qayting</span>";
        }
    }

    function spinNow() {
        if (tries <= 0) return;
        tries--;
        localStorage.setItem('pubg_tries', tries);
        document.getElementById('spin-action').disabled = true;
        
        const deg = Math.floor(Math.random() * 360);
        rotation += 2160 + deg; 
        document.getElementById('wheel-img').style.transform = `rotate(${rotation}deg)`;

        setTimeout(() => {
            const prizes = [5, 100, 20, 0, 60, 10];
            const won = prizes[Math.floor(Math.random() * 6)];
            bal += won;
            localStorage.setItem('pubg_bal', bal);
            
            document.getElementById('status-text').innerText = won > 0 ? `YUTUQ: +${won} UC!` : "OMAD KELMADI";
            refresh();
            if (tries > 0) document.getElementById('spin-action').disabled = false;
        }, 4000);
    }

    function cashOut() {
        if (bal < 360) {
            alert("Yechib olish uchun kamida 360 UC yig'ing!");
        } else {
            let id = prompt("PUBG ID raqamingiz:");
            if (id && id.length > 4) {
                alert("Yuborildi! UC 24 soat ichida " + id + " hisobiga tushadi.");
                bal = 0;
                localStorage.setItem('pubg_bal', 0);
                refresh();
            }
        }
    }

    function usePromo() {
        let p = prompt("Kodni kiriting:");
        if (p === "UZB777") {
            if (localStorage.getItem('promo_used')) return alert("Ishlatilgan!");
            bal += 50;
            localStorage.setItem('pubg_bal', bal);
            localStorage.setItem('promo_used', '1');
            alert("+50 UC bonus berildi!");
            refresh();
        } else { alert("Kod xato!"); }
    }

    refresh();
</script>

</body>
</html>
