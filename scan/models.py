
from django.db import models

class Scan(models.Model):
    url = models.URLField(max_length=200)
    started_at = models.DateTimeField(auto_now_add=True)
    finished_at = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=20, default='pending')  # pending, running, completed, failed
    output = models.TextField(blank=True)  # Store the scan output

    def __str__(self):
        return f"Scan {self.id} for {self.url}"
