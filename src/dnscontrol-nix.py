#!/usr/bin/env python3
import subprocess
import sys
import tempfile

# Constants for command options needing config and creds
INCLUDE_CONFIG = {"preview", "push", "check", "print-ir", "create-domains"}

INCLUDE_CREDS = {
    "preview",
    "push",
    "check-creds",
    "create-domains",
    "get-zone",
    "get-zones",
}

DNSCONTROL_EXECUTABLE = "@dnscontrol@/bin/dnscontrol"


def parseFlakePath(args):
    """Parse and extract flake path from command line arguments."""
    flakePath = "."
    if "--flake" in args:
        idx = args.index("--flake")
        flakePath = args[idx + 1]
        args.pop(idx)  # Remove '--flake'
        args.pop(idx)  # Remove flakePath
    return flakePath, args


def getFlakeAttribute(flakePath, attribute):
    """Get the value of a flake's attribute."""
    try:
        result = subprocess.run(
            [
                "nix",
                "--extra-experimental-features",
                "nix-command",
                "--extra-experimental-features",
                "flakes",
                "eval",
                "--raw",
                f"{flakePath}#{attribute}",
            ],
            stdout=subprocess.PIPE,
            text=True,
            check=True,
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        raise Exception(f"Failed to get {attribute} from {flakePath}: {e}")


def main():
    flakePath, remainingArgs = parseFlakePath(sys.argv)

    try:
        with tempfile.NamedTemporaryFile(mode="w+") as f:
            dnscontrolCommand = [DNSCONTROL_EXECUTABLE] + remainingArgs[1:]

            if set(remainingArgs) & INCLUDE_CONFIG:
                configOutput = getFlakeAttribute(flakePath, "dns.config")
                f.write(configOutput)
                f.flush()
                dnscontrolCommand += ["--config", f.name]

            if set(remainingArgs) & INCLUDE_CREDS:
                credsOutput = getFlakeAttribute(flakePath, "dns.creds")
                dnscontrolCommand += ["--creds", credsOutput]

            subprocess.run(dnscontrolCommand, check=True)

    except Exception as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
