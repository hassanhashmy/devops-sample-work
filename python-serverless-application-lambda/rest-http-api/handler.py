import requests
import json;
import datetime
from datetime import datetime
from dateutil import parser
from dateutil.relativedelta import relativedelta



def endpoint(event, context):
    response = requests.get('http://158.247.202.14:4141/facts').text
    cats = json.loads(response);
    filtered_cats = []
    for cat in cats:
        for key in cat:
            value = cat[key]

            if key == 'date_of_birth':
                datediff = relativedelta(datetime.today(),parser.parse(value));
            if key == 'last_name':
                initial = ord(value[0]);
        pass
        if datediff.years < 10 and initial < 90 and initial >= 65 and initial % 2 == 1 :
            #print(json.dumps(cat, indent=4));
            filtered_cats.append(cat)
    pass
    print("***",cat)
    response = {
        "statusCode": 200,
        "cat": filtered_cats

    }
    
    return response
