# scan/views.py

from django.shortcuts import render, redirect
from .models import Scan
from django.utils import timezone
from django.http import HttpResponse
from django.core.management import call_command
import requests
import subprocess
import os
from urllib.parse import urlparse
from django.conf import settings
import re
from django.http import StreamingHttpResponse
from django.http import JsonResponse
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.shortcuts import render



#######################################################################################################

def extract_exif(request):
    if request.method == 'POST':
        url = request.POST.get('url')
        if url:
            try:
                path = urlparse(url).path
                filename = os.path.basename(path)

                # Download the file using curl with Tor proxy
                file_path = os.path.join(settings.MEDIA_ROOT, filename)
                os.system(f'curl --socks5-hostname localhost:9050 {url} --output media/{filename}')

                # Run exiftool to extract metadata
                result = subprocess.run(['exiftool', file_path], capture_output=True, text=True)

                # Delete the temporary file after extracting metadata
                os.remove(file_path)

                # Render the results in the template
                return render(request, 'scan/extract_exif.html', {'metadata': result.stdout})

            except Exception as e:
                return HttpResponse(f"An error occurred: {str(e)}", status=500)

    return render(request, 'scan/extract_exif.html')

############################################################################################################

def scan_detail(request, scan_id):
    scan = Scan.objects.get(pk=scan_id)
    return render(request, 'scan/scan_detail.html', {'scan': scan})

#################################################################################################


def scan_url(request):
    if request.method == 'POST':
        url = request.POST.get('url')
        collaborator_url = request.POST.get('collaborator_url')

        if url:
            scan = Scan.objects.create(url=url, status='running')

            def run_script():
                cmd = ['/home/prakhar0x01/pre-prod/xpose/script.sh', '-u', url]
                if collaborator_url:
                    cmd += ['-c', collaborator_url]

                process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                output = []

                ansi_escape = re.compile(r'\x1B[@-_][0-?]*[ -/]*[@-~]')  # Regex to remove ANSI escape sequences

                for line in iter(process.stdout.readline, ''):
                    clean_line = ansi_escape.sub('', line)  # Clean the line from ANSI escape sequences
                    output.append(clean_line)
                    scan.output += clean_line
                    scan.save()

                process.stdout.close()
                process.wait()

                with open('results.txt', 'r') as result_file:
                    scan.output += ansi_escape.sub('', result_file.read())  # Clean results.txt content
                    scan.save()
                scan.status = 'Completed'
                return output

            output = run_script()
            return render(request, 'scan/scan_url.html', {
                'scan_id': scan.id,
                'output': ''.join(output),
                'result_url': f'/scan/{scan.id}'
            })

    return render(request, 'scan/scan_url.html')


###############################################################


def index(request):
    scans = Scan.objects.all().order_by('-started_at')
    return render(request, 'scan/index.html', {'scans': scans})

