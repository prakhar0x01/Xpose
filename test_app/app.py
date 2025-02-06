from flask import Flask, request, jsonify, redirect, render_template
import re
import requests

app = Flask(__name__)


proxies = {
    'http': 'socks5h://127.0.0.1:9050',
    'https': 'socks5h://127.0.0.1:9050'
}



@app.route('/')
def home():
    return render_template('index.html')

@app.route('/theory-1')
def theory_1():
    theory_content = "Detailed information about the Hidden Agenda. Leaked documents and insider information are included."
    theory_image = "theory1.png"  # Replace with actual image file
    theory_title = "Theory 1: The Hidden Agenda"
    return render_template('theory.html', theory_title=theory_title, theory_content=theory_content, theory_image=theory_image)

@app.route('/theory-2')
def theory_2():
    theory_content = "Details about the Alien Conspiracy, including classified files and testimonies."
    theory_image = "theory2.png"  # Replace with actual image file
    theory_title = "Theory 2: The Alien Conspiracy"
    return render_template('theory.html', theory_title=theory_title, theory_content=theory_content, theory_image=theory_image)

@app.route('/theory-3')
def theory_3():
    theory_content = "Information on the Financial Elite's covert operations with leaked files and analysis."
    theory_image = "theory3.png"  # Replace with actual image file
    theory_title = "Theory 3: The Financial Elite"
    return render_template('theory.html', theory_title=theory_title, theory_content=theory_content, theory_image=theory_image)



@app.route('/secret-page')
def secret_page():
    return 'This is a secret page.'

@app.route('/contact')
def about():
    return render_template('contact.html')

@app.errorhandler(400)
def bad_request(error):
    return render_template('error.html'), 400


# Fetch remote address once
def get_remote_addr():
    import requests
    try:
        response = requests.get('https://api.ipify.org?format=json')
        response.raise_for_status()
        #return request.remote_addr
        return response.json().get('ip', 'Unknown IP')
    except requests.RequestException:
        return 'Unknown IP'

def is_valid_domain_or_ip(value):
    # Basic validation for IP addresses
    #onion_pattern = re.compile(r'\b(?:[a-z2-7]{16}|[a-z2-7]{56})\.onion\b')
    #onion_pattern = re.compile(r'\b[a-z2-7]{56}\.onion\b')
    ip_pattern = re.compile(r'^(\d{1,3}\.){3}\d{1,3}$')
    # Basic validation for domain names (simplified)
    domain_pattern = re.compile(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    return ip_pattern.match(value) or domain_pattern.match(value)

@app.before_request
def check_and_respond():
    remote_addr = get_remote_addr()

    # Extract headers
    host = request.headers.get('Host')
    x_forwarded_for = request.headers.get('X-Forwarded-For')
    x_forwarded_host = request.headers.get('X-Forwarded-Host')
    x_host = request.headers.get('X-Host')

    # Determine the target domain or IP
    target = None
    for header in (host, x_forwarded_for, x_forwarded_host, x_host):
        if header and is_valid_domain_or_ip(header) and '.onion' not in header:
            target = header
            #print (target) : If you want to see your collaborator url
            break

    if target:
        # Respond to the domain or IP mentioned in the headers
        if not 'http' in target:
            #print(target)
            requests.head(f'http://{target}', proxies=proxies)
            #print('test')
            
        
        return jsonify({
            'Error': 'Invalid Host'
        })

    # If no valid target is found, proceed with other checks
    # Check for downgraded HTTP protocol
    protocol_version = request.environ.get('SERVER_PROTOCOL', '')
    if protocol_version == 'HTTP/1.0':
        return jsonify({
            'error': 'Downgraded HTTP Protocol',
            'ip': remote_addr
        }), 400

    # Check if request size is larger than 1000 bytes
    if request.content_length and request.content_length > 1000:
        return jsonify({
            'error': 'Request Too Large',
            'ip': remote_addr
        }), 400

    # Handle missing Host header
    if not request.headers.get('Host'):
        return jsonify({
            'error': 'No Host Header',
            'ip': remote_addr
        }), 400


"""
@app.route('/')
def home():
    return '''
    <html>
    <head><title>Home</title></head>
    <body>
        <h1>Welcome to the Flask App</h1>
        <p>Navigate to /redirect-me or /check-size to see different behaviors.</p>
    </body>
    </html>
    '''
"""

@app.route('/redirect-me')
def redirect_me():
    remote_addr = get_remote_addr()
    return redirect(f'http://{remote_addr}/redirected-path')


@app.route('/check-size', methods=['POST'])
def check_size():
    # This will trigger the request size validation
    return 'Request size is valid', 200

@app.after_request
def after_request(response):
    # Include ETag header in response
    response.headers['ETag'] = 'W/"5e42b9ee-759"'
    return response

@app.errorhandler(400)
def bad_request(error):
    return jsonify({
        'error': 'Bad Request',
        'ip': get_remote_addr(),
        'details': str(error)
    }), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
