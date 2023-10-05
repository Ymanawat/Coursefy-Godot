extends Node

var http_request: HTTPRequest
var url = "https://www.youtube.com/watch?v=UjLpWUX8nbo&ab_channel=Jokhay"

func _ready():
	http_request = HTTPRequest.new()
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(url)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:  # HTTP OK status code
		var body_text = body.get_string_from_utf8()
		var title_start = body_text.find("<title>") + 7
		var title_end = body_text.find("</title>", title_start)
		if title_start >= 0 and title_end >= 0:
			var title = body_text.substr(title_start, title_end - title_start)
			print("Title of the webpage:", title)
		else:
			print("Title not found in the webpage.")
	else:
		print("Failed to fetch the webpage. Response code:", response_code)
