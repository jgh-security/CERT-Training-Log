def detect_attacks(log_file, output_file):
    with open(log_file, "r") as f:
        lines = f.readlines()

    results = []

    for line in lines:
        # WebShell 탐지
        if "cmd=" in line:
            result = "[ALERT] WebShell detected"
            print(result)
            results.append(result)

        # XSS 탐지
        if "<script>" in line:
            result = "[ALERT] XSS detected"
            print(result)
            results.append(result)

        # SQL Injection 탐지
        if "OR" in line and "1=1" in line:
            result = "[ALERT] SQL Injection detected"
            print(result)
            results.append(result)

    # 결과 파일 저장
    with open(output_file, "w") as f:
        for r in results:
            f.write(r + "\n")


if __name__ == "__main__":
    log_file = "../data/access.log"
    output_file = "../output/result.txt"

    detect_attacks(log_file, output_file)