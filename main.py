import logging
from aiogram import Bot, Dispatcher, types
from aiogram.utils import executor
import time

# SIZNING TOKENINGIZ (Aniq shu yerga qo'ydim)
TOKEN = "8637820333:AAFkZ6NO2rz-uFOFGde2KPim33k25RkFzYY"

# Admin ID (O'zingiznikini yozing)
ADMIN_ID = 5710284858  # Misol tariqasida

logging.basicConfig(level=logging.INFO)

bot = Bot(token=TOKEN)
dp = Dispatcher(bot)

users = {}
FREE_LIMIT = 5

@dp.message_handler(commands=['start'])
async def start(msg: types.Message):
    user_id = msg.from_user.id
    if user_id not in users:
        users[user_id] = {
            "balance": 8000000,
            "used": 0,
            "date": time.strftime("%Y-%m-%d"),
            "premium_until": 0
        }
    await msg.answer("🤖 Xush kelibsiz!\n🎁 BONUS: 8,000,000\n💰 /balance\n🤖 /create\n💎 /premium")

@dp.message_handler(commands=['balance'])
async def balance(msg: types.Message):
    u = users.get(msg.from_user.id)
    if not u: return await msg.answer("Avval /start bosing")
    
    status = "✅ Bor" if time.time() < u["premium_until"] else "❌ Yo‘q"
    await msg.answer(f"💰 Balans: {u['balance']}\n💎 Premium: {status}")

@dp.message_handler(commands=['create'])
async def create(msg: types.Message):
    user_id = msg.from_user.id
    u = users.get(user_id)
    if not u: return await msg.answer("Avval /start bosing")

    if u["balance"] < 100000:
        return await msg.answer("❌ Pul yetarli emas")

    # Limit tekshirish
    today = time.strftime("%Y-%m-%d")
    if u["date"] != today:
        u["date"] = today
        u["used"] = 0

    if time.time() < u["premium_until"] or u["used"] < FREE_LIMIT:
        u["used"] += 1
        u["balance"] -= 100000
        await msg.answer("🤖 Bot yaratildi!")
    else:
        await msg.answer("❌ Kunlik limit tugadi. Premium oling 💎")

if __name__ == '__main__':
    executor.start_polling(dp, skip_updates=True)
