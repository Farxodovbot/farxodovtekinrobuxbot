from aiogram import Bot, Dispatcher, types
from aiogram.utils import executor
import os
import time

# TO'G'IRLANDI: Token qo'shtirnoq ichida bo'lishi kerak
TOKEN = "8637820333:AAFkZ6NO2rz-uF0FGde2KPim33k25RkFzYY"

bot = Bot(token=TOKEN)
dp = Dispatcher(bot)

# TO'G'IRLANDI: Izohlar uchun '#' ishlatiladi
# memory database
users = {}

FREE_LIMIT = 5  # free user limit

# ----------------- START -----------------

@dp.message_handler(commands=['start'])
async def start(msg: types.Message):
    user_id = msg.from_user.id
    if user_id not in users:  
        users[user_id] = {  
            "balance": 8000000,   # 🎁 BONUS  
            "used": 0,  
            "date": time.strftime("%Y-%m-%d"),  
            "premium": False  
        }  
    await msg.answer(  
        "🤖 Botga xush kelibsiz!\n\n"  
        "🎁 BONUS: 8,000,000\n"  
        "💰 /balance\n"  
        "🤖 /create"  
    )

# ----------------- BALANCE -----------------

@dp.message_handler(commands=['balance'])
async def balance(msg: types.Message):
    u = users.get(msg.from_user.id)
    if not u:
        await msg.answer("Avval /start bosing")
        return
    await msg.answer(f"💰 Balans: {u['balance']}")

# ----------------- LIMIT CHECK -----------------

def can_use(user_id):
    u = users.get(user_id)
    if not u:  
        return False  
    if u["premium"]:  
        return True  
    today = time.strftime("%Y-%m-%d")  
    if u["date"] != today:  
        u["date"] = today  
        u["used"] = 0  
    if u["used"] >= FREE_LIMIT:  
        return False  
    u["used"] += 1  
    return True

# ----------------- CREATE BOT -----------------

@dp.message_handler(commands=['create'])
async def create(msg: types.Message):
    user_id = msg.from_user.id
    u = users.get(user_id)
    if not u:  
        await msg.answer("Avval /start bosing")  
        return  
    if u["balance"] < 100000:  
        await msg.answer("❌ Pul yetarli emas")  
        return  
    if not can_use(user_id):  
        await msg.answer("❌ Free limit tugadi. Premium oling 💎")  
        return  
    u["balance"] -= 100000  
    await msg.answer(  
        "🤖 Bot yaratildi!\n"  
        "☁️ Server ulash tayyor"  
    )

# ----------------- PREMIUM -----------------

@dp.message_handler(commands=['premium'])
async def premium(msg: types.Message):
    u = users.get(msg.from_user.id)
    if u:
        u["premium"] = True
        await msg.answer("💎 Premium yoqildi! Endi cheksiz foydalanasiz")

# ----------------- DEFAULT -----------------

@dp.message_handler()
async def other(msg: types.Message):
    await msg.answer("⌨️ /create /balance /premium")

if __name__ == '__main__':
    executor.start_polling(dp, skip_updates=True)
