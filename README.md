echo "import smtplib
from email.message import EmailMessage
msg = EmailMessage()
msg.set_content('Lab Research: Pure Spoof Result.')
msg['Subject'] = 'Pure Spoof Test'
msg['From'] = 'Globo Support <support@globo.io>'
msg['To'] = 'g00glecenter101@gmail.com'
try:
    with smtplib.SMTP('aspmx.l.google.com', 25) as server:
        server.send_message(msg)
        print('SUCCESS: Check your Gmail Spam folder!')
except Exception as e:
    print(f'Error: {e}')" > lab_research.py
