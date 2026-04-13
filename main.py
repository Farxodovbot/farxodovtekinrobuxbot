from aiogram import Bot, Dispatcher, types
from aiogram.utils import executor
from aiogram.types import InlineKeyboardMarkup, InlineKeyboardButton
import os
import time

TOKEN = os.getenv8637820333:AAFkZ6NO2rz-uFOFGde2KPim33k25RkFzYY

bot = Bot(token=TOKEN)
dp = Dispatcher(bot)

users = {}
FREE_LIMIT = 5
PREMIUM_DAYS = 30
ADMIN_ID = 123456789  # <-- o'zingni telegram id yoz

# ----------- START -----------
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

    await msg.answer(
        "🤖 Xush kelibsiz!\n\n"
        "🎁 BONUS: 8,000,000\n"
        "💰 /balance\n"
        "🤖 /create\n"
        "💎 /premium"
    )

# ----------- BALANCE -----------
@dp.message_handler(commands=['balance'])
async def balance(msg: types.Message):
    u = users.get(msg.from_user.id)

    if not u:
        await msg.answer("Avval /start bosing")
        return

    premium_status = "❌ Yo‘q"
    if time.time() < u["premium_until"]:
        premium_status = "✅ Bor"

    await msg.answer(
        f"💰 Balans: {u['balance']}\n"
        f"💎 Premium: {premium_status}"
    )

# ----------- PREMIUM CHECK -----------
def is_premium(user_id):
    u = users.get(user_id)
    if not u:
        return False

    return time.time() < u["premium_until"]

# ----------- LIMIT -----------
def can_use(user_id):
    u = users.get(user_id)
    if not u:
        return False

    if is_premium(user_id):
        return True

    today = time.strftime("%Y-%m-%d")

    if u["date"] != today:
        u["date"] = today
        u["used"] = 0

    if u["used"] >= FREE_LIMIT:
        return False

    u["used"] += 1
    return True

# ----------- CREATE -----------
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
        await msg.answer("❌ Limit tugadi. Premium oling 💎")
        return

    u["balance"] -= 100000

    await msg.answer("🤖 Bot yaratildi!")

# ----------- PREMIUM MENU -----------
def premium_menu():
    kb = InlineKeyboardMarkup()
    kb.add(
        InlineKeyboardButton("💎 30 kun - 1100 UZS", callback_data="buy_30")
    )
    return kb

@dp.message_handler(commands=['premium'])
async def premium(msg: types.Message):
    await msg.answer(
        "💎 Premium olish:\n1100 UZS / 30 kun",
        reply_markup=premium_menu()
    )

# ----------- BUY REQUEST -----------
@dp.callback_query_handler(lambda c: c.data.startswith("buy_"))
async def buy(call: types.CallbackQuery):
    user_id = call.from_user.id

    await bot.send_message(
        ADMIN_ID,
        f"💰 Premium so‘rov!\nUser ID: {user_id}"
    )

    await call.message.answer("💳 To‘lov uchun admin bilan bog‘laning")

# ----------- ADMIN GIVE PREMIUM -----------
@dp.message_handler(commands=['give'])
async def give(msg: types.Message):
    if msg.from_user.id != ADMIN_ID:
        return

    try:
        args = msg.get_args().split()
        user_id = int(args[0])
        days = int(args[1])

        if user_id not in users:
            users[user_id] = {
                "balance": 0,
                "used": 0,
                "date": time.strftime("%Y-%m-%d"),
                "premium_until": 0
            }

        users[user_id]["premium_until"] = time.time() + (days * 86400)

        await msg.answer("✅ Premium berildi")

        await bot.send_message(
            user_id,
            f"💎 Sizga {days} kunlik premium berildi!"
        )

    except:
        await msg.answer("❌ Format:\n/give user_id days")

# ----------- DEFAULT -----------
@dp.message_handler()
async def other(msg: types.Message):
    await msg.answer("⌨️ /create /balance /premium")

executor.start_polling(dp)