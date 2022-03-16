import requests

GOOGLE_API_KEY = 'AIzaSyDT38HAnJEsNT-J1npa7Q9DgMOEDAcn_n0'
GOOGLE_MAPS_BASE_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'


# Fetch nearby restaurant list from a user's location
def get_places(url, location):
    query_url = url + '&' + location

    response = requests.get(query_url).json()
    status = response['status']
    error_message = response['error_message']

    if status == 'REQUEST_DENIED':  # quit if Google API key is not valid
        raise RuntimeError(error_message)

    if status == 'OVER_QUERY_LIMIT':  # quit if Google API key quota reached
        raise RuntimeError(error_message)

    return response['results']


# Extract user location from user information
def get_user_location(user):
    lat = user['address']['geo']['lat']
    lng = user['address']['geo']['lng']
    return lat + ',' + lng


# Fetch users from API
def get_users(url):
    result = {}
    response = requests.get(url)
    if response.status_code == 200:
        result = response.json()

    return result


if __name__ == '__main__':
    # set query url for search nearby places against Google Maps
    # which search for sushi restaurant which is 500 meters a given location
    url = f'{GOOGLE_MAPS_BASE_URL}?key={GOOGLE_API_KEY}&type=restaurant&keyword=sushi&radius=500'

    users = get_users('https://jsonplaceholder.typicode.com/users')
    location = get_user_location(users[0])
    places = get_places(url, location)

    for place in places:
        if place['rating'] > 4:  # get restaurant with rating > 4 only
            print(f"{Name: place['name']} rate: {place['rating']}")
