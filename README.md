# XPOSE

## 1. Overview of the Project & Problem Statement

### Title: Overview of the Project

#### Content:
- The dark web is increasingly used for illegal activities, with numerous underground marketplaces facilitating the buying and selling of illicit items such as drugs, weapons, data leaks, counterfeit money, and forged documents. These platforms, operating anonymously, pose significant challenges to law enforcement agencies (LEAs), making it difficult to identify the individuals behind these marketplaces, especially on the TOR network. 

#### Description:
- Operating illegal sites on the dark web requires minimal technical resources: simply access to the TOR browser and the TORRC file. For hosting, individuals can use either paid or free hosting servers. Running on the TOR network (V3) provides near-impenetrable anonymity, complicating the identification of underground operators. These operators typically use ISPs and VPNs to further obscure their locations.

#### Expected Solution:
- The objective of this project is to develop a tool or technique capable of identifying the operators behind dark web marketplaces. Participants will focus on discovering the actual IP or VPN addresses associated with these operators and identifying any other personally identifiable information (PII) related to the individuals behind the onion sites.

---

## 2. Proposed Solution

### Introducing Xpose

Xpose is a powerful software solution for performing advanced **deanonymization** techniques, designed to trace the operators behind illegal dark web sites. The system includes both a **web app** and **CLI (Command Line Interface)** to offer flexibility and reliability. 

Xpose leverages cutting-edge research in deanonymization techniques, providing highly accurate methods for exposing the **VPN** or **ISP IP** addresses of target onion sites. In addition to IP exposure, Xpose employs advanced **OSINT** (Open Source Intelligence) methods such as:
- **EXIF metadata extraction**
- **Reverse image search**
- **IRC (Internet Relay Chat) analysis**

Additionally, modern fingerprinting techniques are used to analyze the behavior of onion site operators over time.

---

## 3. Technical Approach

### Key Methods and Techniques Used

1. **Advanced OSINT**: Extracting EXIF metadata, performing reverse image searches, and analyzing IRCs.
2. **Latest Research**: Manipulating HTTP messages for more effective deanonymization.
3. **Scanning for OPSEC Flaws**: Identifying poor operational security practices on dark web sites, including server misconfigurations and PII leaks.
4. **End-user Attacks**: Using timing correlation attacks to track the individuals behind onion sites.
5. **Advanced Fingerprinting**: Analyzing HTTP headers, SSH fingerprints, and certificate hashes.
6. **Target Site Exploitation**: Techniques like exploiting recent 0-days, Local File Inclusion (LFI) vulnerabilities, and Server-Side Request Forgery (SSRF) to disclose actual IP addresses.

### Proof Of Concept
[VIDEO POC](https://drive.google.com/file/d/14LIEzJmlQyBu_BjXFTkY7GBJszjAbElg/view?usp=sharing)

### Tech Stack Used

- **TOR Daemon**: For interaction with the TOR network.
- **cURL**: To implement advanced deanonymization techniques, such as manipulating HTTP messages.
- **Python**: Provides the flexibility needed for various tasks on the TOR network.
- **Django**: For web application development.
- **Bash**: For automation and CLI tasks.
- **SQLite3**: For data storage and management.
- **HTML, JavaScript, Bootstrap**: For building a dynamic and responsive user interface.
- **Linux**: Operating system used for development and operations.
- **AWS**: For **CI/CD** (Continuous Integration/Continuous Delivery).
- **Others**: EXIF-tools, Google reverse image search, Git/GitHub, etc.

---

## 4. Feasibility & Viability

### Time Stability:
- Xpose provides quick and effective results, saving valuable time compared to manual deanonymization techniques.

### Accuracy:
- Our solution avoids the use of AI or machine learning, ensuring highly accurate results. Only definitive data is provided, avoiding false positives.

### Scalability:
- The solution is designed to scale as new techniques are developed, ensuring it remains effective in the future.

### Captchas & Timeouts:
- Xpose is equipped to handle various CAPTCHAs and timeouts encountered on onion sites. Solutions to these challenges will be included in future updates.

### In-depth Enumeration:
- Xpose doesn’t just focus on deanonymization; it also employs OSINT and fingerprinting techniques for more comprehensive research.

### Privacy & Security:
- Xpose allows researchers to conduct their work in a secure and controlled environment, ensuring no harm to organizational privacy or infrastructure.

---

## 5. Impact & Benefits

### Title: Importance and Audience

#### Content:
- **Potential Impact / Benefits**:
  - **Intelligence Agencies**: Used for gathering critical intelligence.
  - **Law Enforcement Agencies (LEAs)**: A vital tool for tracking and investigating illegal activities.
  - **Security Researchers & Cybersecurity Experts**: An essential resource for contributing to the fight against dark web crimes.
  - **Cyber Threat Intelligence Teams**: Helping businesses and organizations detect and protect against dark web threats.

---

## 6. References & Research

- [Using Python to Monitor Dark Web](https://www.digitalforensicstips.com/2023/01/using-python-to-monitor-onion-dark-web.html)
- [Dark Web Scraping Using Python](https://hoxframework.com.hr/?p=473)
- [Is TOR Still Anonymous?](https://youtu.be/-uDYvy2jQzM?si=UrVGUBlkLLikg9VP)
- [Edward Snowden Research](https://www.theguardian.com/world/interactive/2013/oct/04/tor-stinks-nsa-presentation-document)
- [DEFCON-22: How People Got Caught](https://youtu.be/eQ2OZKitRwc?si=P1gPeP9lVDg9g6Fs)
- [DEFCON-22: Touring the Dark Side of the Internet](https://youtu.be/To5yarfAg_E?si=Ek9lqNOYeLy-cCbb)
- [Bad OPSEC: How TOR Users Got Caught](https://youtu.be/GR_U0G-QGA0?si=UaX2Fp_vW1faqTrl)
- [Deanonymization of TOR HTTP Hidden Services](https://www.youtube.com/watch?v=v45_tkKCJ54)
- [Uncovering Tor Hidden Service with Etag](https://sh1ttykids.medium.com/new-techniques-uncovering-tor-hidden-service-with-etag-5249044a0e9d)
- [OnionScan: Practical Deanonymization of Hidden Services](https://www.youtube.com/watch?v=r8hr0nlfJRc&pp=ygUVZGVhbm9ueW1pemluZyBkYXJrd2Vi)
