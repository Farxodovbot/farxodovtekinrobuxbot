<!DOCTYPE html>
<html lang="uz">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UC TERMINAL | Official Spin</title>
    <style>
        /* Umumiy ko'rinish */
        body { margin: 0; background: #0c0c0e; color: white; font-family: 'Arial', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; overflow-x: hidden; }
        .app-container { width: 90%; max-width: 360px; background: #151518; padding: 25px; border-radius: 30px; border: 1px solid #2a2a2a; text-align: center; position: relative; box-shadow: 0 20px 50px rgba(0,0,0,0.7); }
        
        /* Balans qismi */
        .balance-card { background: linear-gradient(145deg, #1e1e21, #161619); padding: 20px; border-radius: 20px; margin-bottom: 30px; border: 1px solid #333; }
        .bal-label { font-size: 11px; color: #777; text-transform: uppercase; letter-spacing: 2px; }
        .bal-value { font-size: 45px; font-weight: bold; color: #f1c40f; text-shadow: 0 0 15px rgba(241, 196, 15, 0.3); }

        /* Baraban dizayni */
        .wheel-box { position: relative; width: 250px; height: 250px; margin: 0 auto 30px auto; }
        #wheel { width: 100%; height: 100%; border-radius: 50%; border: 10px solid #222; transition: transform 4s cubic-bezier(0.15, 0, 0.15, 1);
            background: conic-gradient(
                #e74c3c 0deg 60deg, 
                #3498db 60deg 120deg, 
                #f1c40f 120deg 180deg, 
                #2ecc71 180deg 240deg, 
                #9b59b6 240deg 300deg, 
                #e67e22 300deg 360deg
            );
        }
        .pointer { position: absolute; top: -15px; left: 50%; transform: translateX(-50%); width: 0; height: 0; border-left: 15px solid transparent; border-right: 15px solid transparent; border-top: 30px solid #fff; z-index: 5; filter: drop-shadow(0 5px 10px rgba(0,0,0,0.5)); }

        /* Tugmalar */
        .btn { display: block; width: 100%; padding: 16px; margin: 12px 0; border-radius: 15px; border: none; font-weight: bold; font-size: 16px; cursor: pointer; transition: 0.3s; }
        .btn-spin { background: #ffffff; color: #000; box-shadow: 0 5px 20px rgba(255,255,255,0.1); }
        .btn-spin:active { transform: scale(0.95); }
        .btn-spin:disabled { background: #222; color: #555; cursor: not-allowed; }
        
        .btn-claim { background: #27ae60; color: white; }
        .btn-promo { background: transparent; border: 1px solid #444; color: #888; font-size: 13px; }

        #msg { height: 30px; font-weight: bold; margin-bottom: 10px; color: #f1c40f; }
    </style>
</head>
<body>

<div class="app-container">
    <h2 style="margin-top:0; color: #eee; font-size: 20px;">PUBG UC SPIN</h2>
    
    <div class="balance-card">
        <div class="bal-label">Sizning Balansingiz</div>
        <div class="bal-value"><span id="uc-count">0</span></div>
        <div style="font-size: 10px; color: #444;">MINIMUM: 360 UC</div>
    </div>

    <div class="wheel-box">
        <div class="pointer"></div>
        <div id="wheel"></div>
    </div>

    <div id="msg"></div>

    <button class="btn btn-spin" id="spin-button" onclick="spin()">AYLANTIRISH (3/3)</button>
    <button class="btn btn-claim" onclick="withdraw()">YECHIB OLISH</button>
    <button class="btn btn-promo" onclick="promo()">PROMOKOD</button>
</div>

<script>
    let uc = parseInt(localStorage.getItem('uc_total')) || 0;
    let limit = parseInt(localStorage.getItem('uc_limit')) || 3;
    let rotation = 0;

    function update() {
        document.getElementById('uc-count').innerText = uc + " UC";
        document.getElementById('spin-button').innerText = `AYLANTIRISH (${limit}/3)`;
        if(limit <= 0) document.getElementById('spin-button').disabled = true;
    }

    function spin() {
        if(limit <= 0) return;
        
        limit--;
        localStorage.setItem('uc_limit', limit);
        document.getElementById('spin-button').disabled = true;
        
        const randomDeg = Math.floor(Math.random() * 360);
        rotation += 1800 + randomDeg; 
        document.getElementById('wheel').style.transform = `rotate(${rotation}deg)`;

        setTimeout(() => {
            const wins = [10, 50, 0, 100, 5, 20];
            const result = wins[Math.floor(Math.random() * wins.length)];
            
            uc += result;
            localStorage.setItem('uc_total', uc);
            
            const msgEl = document.getElementById('msg');
            msgEl.innerText = result > 0 ? `TABRIKLAYMIZ: +${result} UC!` : "OMAD KELMADI";
            
            update();
            if(limit > 0) document.getElementById('spin-button').disabled = false;
        }, 4000);
    }

    function withdraw() {
        if(uc < 360) {
            alert("Yechish uchun kamida 360 UC kerak!");
        } else {
            let pid = prompt("PUBG ID-ingizni kiriting:");
            if(pid) {
                alert("So'rov yuborildi! UC 24 soatda tushadi.");
                uc = 0;
                localStorage.setItem('uc_total', 0);
                update();
            }
        }
    }

    function promo() {
        let code = prompt("Kodni kiriting:");
        if(code === "UZB2026") {
            if(localStorage.getItem('p_used')) return alert("Ishlatilgan!");
            uc += 60;
            localStorage.setItem('uc_total', uc);
            localStorage.setItem('p_used', 'true');
            update();
            alert("+60 UC qo'shildi!");
        } else {
            alert("Xato kod!");
        }
    }

    update();
</script>

</body>
</html>
