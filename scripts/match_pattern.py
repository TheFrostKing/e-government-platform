import re,json

jformated = ""
folder_frontend = 'frontend_definition.json'
backend_definition = 'backend_definition.json'
backend_role ='"requiresCompatibilities": ["FARGATE"], "networkMode": "awsvpc","taskRoleArn": "arn:aws:iam::901935996178:role/ecsTaskExecutionRole","executionRoleArn": "arn:aws:iam::901935996178:role/ecsTaskExecutionRole", "cpu":"1vCPU",  "memory":"8192"'

frontend_role = '"requiresCompatibilities": ["FARGATE"], "networkMode": "awsvpc","taskRoleArn": "arn:aws:iam::901935996178:role/ecsTaskExecutionRole","executionRoleArn": "arn:aws:iam::901935996178:role/ecsTaskExecutionRole", "cpu":"1vCPU",  "memory":"2048"'

for folder in [folder_frontend, backend_definition]:
    with open(folder) as file:
        jfix = json.load(file)
        jtext = json.dumps(jfix)
        text_list = re.findall(r'(?s)("containerDefinitions".+?"family".+?".+?"),', jtext)
        new_text=text_list[0]
        # .replace('"environment": []', '"memory": "30gb"')

    if folder == folder_frontend:
        new_text = '{' + new_text + ',' + '' + frontend_role + '}'
        with open('output_frontend.json', 'a') as outfile:
            outfile.write(new_text)
    else:
        new_text = '{' + new_text + ',' + '' + backend_role + '}'
        with open('output_backend.json', 'a') as outfile:
            outfile.write(new_text)
    

