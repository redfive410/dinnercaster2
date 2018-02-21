import boto3
import json
import urllib2
import os
import random

# --------------- Helpers that build all of the responses ----------------------

def build_speechlet_response(title, output):
    return {
        'outputSpeech': {
            'type': 'PlainText',
            'text': output
        },
        'card': {
            'type': 'Simple',
            'title': "SessionSpeechlet - " + title,
            'content': "SessionSpeechlet - " + output
        },
    }


def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }

# --------------- Functions that control the skill's behavior ------------------

def get_dinner_response():
    client = boto3.client('lambda')

    response = client.invoke(
        FunctionName='dinnercaster2-get-dinnerlist'
    )

    dinners = json.loads(response['Payload'].read())
    url = "http://api.wunderground.com/api/" + os.environ['wunderground_api_key'] + "/conditions/q/CA/Poway.json"
    response = urllib2.urlopen(url)
    weather = json.loads(response.read())
    day = weather['current_observation']['local_time_rfc822'][0:3]
    temp = weather['current_observation']['temp_f']

    names = []
    day_scores = []
    general_scores = []
    weather_scores = []

    for i in range(len(dinners)):
      names.append(dinners[i]['dinnername'])

      scores = json.loads(dinners[i]['scores'])
      general_scores.append(scores['GeneralScore'])

      if temp < 80:
          weather_scores.append(scores['ColdWeatherScore'])
      else:
          weather_scores.append(scores['HotWeatherScore'])

      if day == "Mon":
          day_scores.append(scores['MondayScore'])
      elif day == "Tue":
          day_scores.append(scores['TuesdayScore'])
      elif day == "Wed":
          day_scores.append(scores['WednesdayScore'])
      elif day == "Thu":
          day_scores.append(scores['ThursdayScore'])
      elif day == "Fri":
          day_scores.append(scores['FridayScore'])
      elif day == "Sat":
          day_scores.append(scores['SaturdayScore'])
      elif day == "Sun":
          day_scores.append(scores['SundayScore'])

    final_scores = {}
    dinner_ideas = []

    for i in range(len(names)):
      final_scores[names[i]] = general_scores[i] * (day_scores[i] + weather_scores[i])

      if final_scores[names[i]] > 25:
        dinner_ideas.append(names[i])

    print final_scores

    card_title = "Dinnercaster"
    speech_output = "Here's your dinner idea: " + random.choice(dinner_ideas)
    return build_response(None, build_speechlet_response(
        card_title, speech_output))

# --------------- Events ------------------

def on_intent(intent_request):
    print("on_intent requestId=" + intent_request['requestId'])

    intent = intent_request['intent']
    intent_name = intent_request['intent']['name']

    # Dispatch to your skill's intent handlers
    if intent_name == "DinnerCasterIntent":
        return get_dinner_response()
    elif intent_name == "AMAZON.HelpIntent":
        return
    elif intent_name == "AMAZON.CancelIntent" or intent_name == "AMAZON.StopIntent":
        return
    else:
        raise ValueError("Invalid intent")

# --------------- Main handler ------------------

def lambda_handler(event, context):

    """
    Uncomment this if statement and populate with your skill's application ID to
    prevent someone else from configuring a skill that sends requests to this
    function.
    """
    # if (event['session']['application']['applicationId'] !=
    #         "amzn1.echo-sdk-ams.app.[unique-value-here]"):
    #     raise ValueError("Invalid Application ID")
    if event['request']['type'] == "LaunchRequest":
        return get_dinner_response()
    if event['request']['type'] == "IntentRequest":
        return on_intent(event['request'])
