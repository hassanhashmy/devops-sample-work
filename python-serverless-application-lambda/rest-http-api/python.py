import requests;
import json;
from datetime import datetime
from dateutil import parser
from dateutil.relativedelta import relativedelta

res = requests.get('http://158.247.202.14:4141/facts').text;

cats = json.loads(res);

#print(json.dumps(cats, indent=4));
for cat in cats:
    for key in cat:
        value = cat[key]
        
        if key == 'date_of_birth':
            datediff = relativedelta(datetime.today(),parser.parse(value));
           # print(datediff.years);
        if key == 'last_name':
            initial = ord(value[0]);
            #print(initial);
    pass
    if datediff.years < 10 and initial < 90 and initial >= 65 and initial % 2 == 1 :
        print(json.dumps(cat, indent=4));
pass

