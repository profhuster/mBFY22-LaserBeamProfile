print("SCPI_22c")
import SCPI_Functions

(nameList, fcnList) = SCPI_Functions._init()
print(f"nameList = >{nameList}<")

# Get help function
for i in range(len(nameList)):
    if 'help' == nameList[i]:
        helpFcn = fcnList[i]
helpFcn()

# Main SCPI Loop
while True:
    response = input(">> ").lower().strip()
    print(f">{response}<")
    
    found = False
    for i in range(len(nameList)):
        # Find function
        if nameList[i] in response:
            found = True
            # Find args, if any
            if len(response) > len(nameList[i]):
                arg = response[len(nameList[i]):]
                fcnList[i](arg)
            else:
                fcnList[i]()
            break

    if not found:
        print(response, "Not found")
        helpFcn()

# EOF