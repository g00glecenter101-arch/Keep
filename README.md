cat <<EOF > lab_research.py
import smtplib
from email.message import EmailMessage

msg = EmailMessage()
msg.set_content("Success! Sent from Ubuntu VPS. Is 'Steve' gone?")
msg['Subject'] = "Pure Spoof Test"
msg['From'] = "Globo Support <support@globo.io>"
msg['To'] = "g00glecenter101@gmail.com"

try:
    # This connects to Google's receiving server (Port 25)
    # It does NOT ask for a password, so 'Steve' isn't added!
    with smtplib.SMTP('aspmx.l.google.com', 25) as server:
        server.send_message(msg)
        print("-----------------------------------------")
        print("DONE! Check your Gmail SPAM folder now.")
        print("-----------------------------------------")
except Exception as e:
    print(f"Error: {e}")
EOF
