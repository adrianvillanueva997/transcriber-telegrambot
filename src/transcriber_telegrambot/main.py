import logging
import os
import subprocess
from shutil import ExecError

from dotenv import load_dotenv
from rich.logging import RichHandler
from telegram import Update
from telegram.ext import (
    Application,
    CommandHandler,
    ContextTypes,
    MessageHandler,
    filters,
)

# Enable logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
    handlers=[RichHandler()],
)
logger = logging.getLogger(__name__)


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Send a message when the command /help is issued."""
    await update.message.reply_text("Help!")


async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Echo the user message."""
    voice_file = await context.bot.get_file(update.message.voice.file_id)
    logging.info(update.message.voice)
    await voice_file.download("audio.ogg")
    try:
        output = subprocess.run(
            ["vosk-transcriber", "-l", "es", "-i", "audio.ogg", "-o", "output.txt"],
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        if output.returncode == 0:
            with open("output.txt", "r") as file:
                content = file.read()
                await update.message.reply_text(
                    text=content, reply_to_message_id=update.message.id
                )
    except ExecError as e:
        logging.warning(e)


def main() -> None:
    load_dotenv()
    """Start the bot."""
    # Create the Application and pass it your bot's token.
    application = Application.builder().token(os.environ["bot_token"]).build()

    # on different commands - answer in Telegram
    application.add_handler(CommandHandler("help", help_command))

    # on non command i.e message - echo the message on Telegram
    application.add_handler(MessageHandler(~filters.COMMAND, echo))

    # Run the bot until the user presses Ctrl-C
    application.run_polling()


if __name__ == "__main__":
    main()
