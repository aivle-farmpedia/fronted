import requests
import urllib.parse
import json

# API 엔드포인트 URL
url = "https://api.odcloud.kr/api/3067702/v1/uddi:a8e75ec2-e6bb-4aa0-9bcc-a4af87a8aec8?page=1&perPage=10"

# 파라미터 설정
params = {
    "연번": 0,
    "사업명": "string",
    "대상 및 자격조건": "string",
    "지원기준": "string",
    "데이터기준일": "string"
} 

# URL에 파라미터 추가
url_with_params = f"{url}?{'&'.join([f'{key}={value}' for key, value in params.items()])}"

# GET 요청 보내기
response = requests.get(url_with_params)

# 응답 확인
if response.status_code == 200:
    data = response.json()
    
    # JSON 파일로 저장
    with open('assets/policies.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
    print("Data has been saved to policies.json")
else:
    print("Error:", response.status_code)
