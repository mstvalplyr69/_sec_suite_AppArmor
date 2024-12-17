# _sec_suite_AppArmor
Author - This is my first attempt to really build something like this, so my structure may not be comparable to common practice, but any suggestion would be appreciated. 
---

# Protocol Z - Security Suite

## Overview

This toolset, tentatively named **Protocol Z**, leverages **AppArmor** to automate critical security functions that are often unavailable or underutilized. The goal is to educate users on potential vulnerabilities, reduce intrusion risks, and create a secure yet user-friendly environment.

### Why Protocol Z?

Many users unknowingly prioritize convenience over security, leaving their systems exposed. A hardened environment ensures that all activities, including internet traffic and program execution, undergo rigorous validation checks, minimizing the risk of unauthorized access or data exposure.

Modern threats have evolved from obvious scams to sophisticated, nearly invisible tactics. Attackers now target systems designed for defense, exploiting even advanced countermeasures. This shift underscores the importance of proactive and adaptive security measures.

While no system can be completely secure, Protocol Z focuses on **continuous improvement** and **robust defense**, evolving alongside the threat landscape.

---

## The AppArmor Approach

Protocol Z employs **AppArmor**, a Linux kernel security module, to isolate applications using predefined access profiles. These profiles limit applications' capabilities without compromising functionality. The automated process detects new applications in designated folders, assigns profiles or guides users through a three-step vetting process to generate a profile to match the application.

### The simple 3-step process:
1. **Sandbox:** Isolate the application in a secure sandbox to monitor its behavior and detect any suspicious activity.
2. **Audit:** Investigate the application for hidden malware and generate a report for user review. This includes listing events that trigger communication with external entities.
3. **Compliance:** Find a balance between restricting the application's behavior and ensuring it remains 100% effective for the user.

Until an application completes the vetting process, it remains confined to a sandboxed user space, reducing potential security risks.

---

## Key Features

- **Real-Time Monitoring:** Detects new software installations and initiates the security vetting process.
- **Profile Management:** Automatically assigns existing profiles or generates new ones.
- **Sandboxing:** Restricts unvetted applications to a safe user space.
- **Interactive Security:** Prompts users during vetting for greater accuracy and oversight.
- **Custom Rules:** Supports predefined rules tailored to user environments.

### Visibility Levels

The monitoring system includes three levels of visibility:
1. **Low (1):** Minimal resource usage; checks triggered less frequently.
2. **Medium (2):** Balanced monitoring and resource usage.
3. **High (3):** Active, frequent checks with higher hardware demands.

---

## Workflow Example

1. A new application, `example-app`, is detected.
2. No existing AppArmor profile is found, so a new profile is generated.
3. The user is prompted to choose a profile mode:
   - **Enforce:** Strictly enforces rules.
   - **Audit:** Logs unauthorized actions without enforcing rules.
   - **Complain:** Logs unauthorized actions while allowing operations.

### Example Prompt:

```bash
New application detected: example-app
No AppArmor profile found. A new profile has been created.
Select profile mode:
1. Enforce
2. Audit
3. Complain
Enter your choice (1/2/3):
```

---

## Installation

### Prerequisites
- **Operating System:** Linux (Ubuntu or any distribution with AppArmor enabled).
- **Dependencies:**
  - AppArmor (`aa-genprof`, `aa-complain`, `aa-enforce` commands).
  - Bash shell.

#### To Install AppArmor (Ubuntu):

```bash
sudo apt update && sudo apt install apparmor apparmor-utils
```

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/monitor-app-installs.git
   cd monitor-app-installs
   ```
2. Make the script executable:
   ```bash
   chmod +x monitor_app_installs.sh
   ```
3. (Optional) Edit predefined rules in `config/predefined_rules.txt`.

### Usage

Run the script:

```bash
./monitor_app_installs.sh
```

Follow the prompts to:

- Review detected installations.
- Set the profile mode (`enforce`, `audit`, or `complain`).

---

## Repository Structure

```
monitor-app-installs/
├── README.md               # Documentation
├── LICENSE                 # License file
├── monitor_app_installs.sh # Main script
├── config/                 # Predefined AppArmor rules
│   ├── predefined_rules.txt
├── docs/                   # Additional documentation
├── tests/                  # Test scripts (optional)
└── .gitignore              # Ignored files
```

---

## Future Enhancements

- **Enhanced Alerts:** Add support for email, Slack, or other notification channels.
- **Logging:** Implement detailed audit trails for improved tracking.
- **Expanded Rules:** Include profiles for a broader range of applications.

---

## Contributing

We welcome contributions! To get started:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature: feature-name"
   ```
4. Push your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request on GitHub.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [AppArmor Documentation](https://wiki.ubuntu.com/AppArmor)
- Community resources on Bash scripting.

---

## Future Enhancements

- Add support for multiple alert channels (e.g., email, Slack).
- Implement logging for better audit trails.
- Expand predefined rules to cover more applications.

---

Feel free to explore, use, and contribute to this project. Happy monitoring!
