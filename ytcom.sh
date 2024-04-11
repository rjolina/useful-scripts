#!/bin/bash

# Check if youtube-comment-downloader is installed, if not, install it
if ! command -v ~/.local/bin/youtube-comment-downloader &> /dev/null; then
    pip3 install https://github.com/egbertbouman/youtube-comment-downloader/archive/master.zip
fi
# Accept URL and output file name from input
INPUTURL="$1"
OUTPUTFILE="${2:-comments_output.html}"  # Default output file name if not provided

# Download comments to JSON file
~/.local/bin/youtube-comment-downloader -p -s 0 --url "$INPUTURL" -o /tmp/ccc.json

# Execute Python script to generate HTML
python3 <<EOF
import json
from jinja2 import Environment, FileSystemLoader
from datetime import datetime

# Load data from JSON file
with open('/tmp/ccc.json', 'r') as file:
    data = json.load(file)

# Prepare data for the template
comments = data["comments"]
for comment in comments:
    comment['indent'] = '<blockquote>' * comment.get('reply', False)  # Indentation for replies
    comment['readable_time'] = datetime.fromtimestamp(comment['time_parsed']).strftime('%Y-%m-%d %H:%M:%S')

# Define the HTML template
TEMPLATE = """
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Komentarze</title>
   <style>
    body {
        width: 70%;
        margin: auto;
        line-height: 1.5; /* odstęp między liniami */
        font-family: 'Open Sans', Arial, sans-serif; /* wybór czcionki */
    }
    i {
        color: darkblue;
    }
    b {
        color: darkred; /* kolor bordowy */
    }
    hr {
        border: none;
        border-top: 1px dotted #000;
        text-align: center;
        width: 50%;
        margin: 10px auto;
    }

    @media (prefers-color-scheme: dark) {
        body {
            background-color: #333; /* ciemne tło */
            color: #ccc; /* jasny tekst */
        }
        i {
            color: lightblue;
        }
        b {
            color: #ff6347; /* jaśniejszy czerwony w trybie ciemnym */
        }
        hr {
            border-top: 1px dotted #ccc;
        }
    }
</style>

</head>
<body>
{% for comment in comments %}
    {{ comment.indent }}
    <p><b>{{ comment.author }}</b> - <i>{{ comment.readable_time }} </i></p>
    <p>{{ comment.text }}<span style="display: block; text-align: left; font-size: small; color: green; font-weight: bold;">👍{{ comment.votes }}</span>
</p>
    {% if comment.get('reply', False) %}</blockquote>{% endif %}
    <hr>
{% endfor %}
</body>
</html>
"""

# Configure Jinja2
env = Environment(loader=FileSystemLoader('.'))
template = env.from_string(TEMPLATE)

# Generate HTML from the template
html_output = template.render(comments=comments)

# Save the result to an HTML file
with open('$OUTPUTFILE', 'w') as f:
    f.write(html_output)

print("Generated HTML file: $OUTPUTFILE")
EOF


