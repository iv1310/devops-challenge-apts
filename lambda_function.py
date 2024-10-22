import json


def lambda_handler(event, context):
    print(event)

    greeter = "World"
    simulate_error = False

    # Check for a query params to simulate an simulate_error
    try:
        if (
            event["queryStringParameters"]
            and event["queryStringParameters"]["simulate_error"] == "true"
        ):
            simulate_error = True
    except KeyError:
        print("No greeter")

    try:
        if (
            (event["queryStringParameters"])
            and (event["queryStringParameters"]["greeter"])
            and (event["queryStringParameters"]["greeter"] is not None)
        ):
            greeter = event["queryStringParameters"]["greeter"]
    except KeyError:
        print("No greeter")

    try:
        if (
            (event["multiValueHeaders"])
            and (event["multiValueHeaders"]["greeter"])
            and (event["multiValueHeaders"]["greeter"] is not None)
        ):
            greeter = " and ".join(event["multiValueHeaders"]["greeter"])
    except KeyError:
        print("No greeter")

    try:
        if (
            (event["headers"])
            and (event["headers"]["greeter"])
            and (event["headers"]["greeter"] is not None)
        ):
            greeter = event["headers"]["greeter"]
    except KeyError:
        print("No greeter")

    if (event["body"]) and (event["body"] is not None):
        body = json.loads(event["body"])
        try:
            if (body["greeter"]) and (body["greeter"] is not None):
                greeter = body["greeter"]
        except KeyError:
            print("No greeter")

    # Simulate a 500 error if the flag is set
    if simulate_error:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Simulated Internal Server Error"}),
        }

    res = {
        "statusCode": 200,
        "headers": {"Content-Type": "*/*"},
        "body": "Hello, " + greeter + "!",
    }

    return res
