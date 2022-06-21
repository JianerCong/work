# $ pip3 install pyyaml
from datetime import date
import datetime
import subprocess
import sys
import yaml

def get_abbrev(s):
    # get the abbreviation for the string s
    # Example: get_abbrev('apple tree') ⇒ AT
    result = ''
    for word in s.strip().split(' '):
        result += word[0]
    return result.upper()

def get_greeting(h):
    h = int(h)
    if (h > 4 and h < 12):
        return 'Good Morning'
    elif (h >= 12 and h < 18):
        return 'Good Afternoon'
    elif (h >= 18 and h < 22):
        return 'Good Evening'
    elif (h >=22 and h < 24):
        return 'Bedtime soon'
    else:
        return 'Why you are still awake'

with open('profile.yaml', 'r') as f:
    p = yaml.safe_load(f)

# get basic info --------------------------------------------------
d_today = date.today()
d_birthday = date.fromisoformat(p['dateOfBirth'])

t_now = datetime.datetime.now()

year_start=int(p['study']['start year'][:4])
year_end=int('20' + p['study']['expected end year'][5:])

day_in_uni = (date(year_end,5,12) - date(year_start,10,1)).days
day_in_life = (d_today - d_birthday).days
portion_in_uni = '%.2g %%' % (100 * day_in_uni / day_in_life)

greeting=get_greeting(t_now.strftime("%H"))
uni=p["study"]["uni"]
deg=p['study']['intended qualification'].split(' ')[0].lower()

# get the system info
s = subprocess.check_output(['cat','/etc/issue'],stderr=subprocess.STDOUT)
sys_info = s.decode().split(' ')

whatday = 'Weekday' if d_today.strftime('%u') in '12345' else 'Weekend'

# Start interation--------------------------------------------------
name = input('    Hi there, how should I call you: ')
cv = f'''
    --------------------------------------------------
    Hi {name}, my name is {p["name"]["first"]} {p["name"]["last"]}.
    Just call me {p["name"]["first"]}. I am from China.
    At the time of this writing, it's {d_today.strftime("%d %B %G")}.
    Today is {d_today.strftime("%A")}. {whatday}.
    Now it's {t_now.strftime("%I:%M %p")},so perhaps I should say \"{greeting}\".
'''+ f'''
    I am {d_today.year - d_birthday.year} years old, to be exact, it's {day_in_life} days (upto today).
    I am from {get_abbrev(uni)}, short for {uni}.
    It's a  {year_end - year_start}-year programme.I started it when I was {year_start - d_birthday.year}.
    So, approximately  {portion_in_uni} of my life is spent in this place.

    If nothing goes wrong, I should be able to get a {deg} degree this summer.
    '''

print(cv,'    Something that I am comfortable with are:\n',end='    \t')
l = p['stokes']; print(*l[:-1],sep=", ", end=", "); print(f'and {l[-1]}.')
print(f"""
    That's it.
    This script is run by Python {sys.version.split(' ')[0]} under system {sys_info[0]} {sys_info[1]}.
""")
print('    --------------------------------------------------\n')

# Ask for answer --------------------------------------------------
maximum_patient = 3
rejected = False
while not rejected:
    r = input("\n    So yeah. Do you want to give me a chance? [y/n]: ")
    if r.lower()[0] == 'y':
        print('    Thanks boss.')
        exit()
    else:
        patient = maximum_patient
        while patient > 0:
            r = input( '    ' +
                       (maximum_patient + 1 - patient) * 'Really '
                       + "? You wanna say no?[y/n]: ")
            if r.lower()[0] == 'n':
                break
            else:
                patient -= 1
        if patient == 0:
            rejected = True
print('    Fine, bye bye.')
