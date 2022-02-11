from flask import Flask, request, Response
from graphene import Field, Int, List, ObjectType, Schema, String
import json, os

environment_var_key = 'environment'
local_environment = 'local'

response_type_key = 'Content-Type'
response_type = 'application/json'

graphql_route = '/graphql'
supported_methods = ['POST']

host = '127.0.0.1'
port = 8080

'''
  Example data
'''
authors = [
	{ 'id': 1, 'name': 'J. K. Rowling' },
	{ 'id': 2, 'name': 'J. R. R. Tolkien' },
	{ 'id': 3, 'name': 'Brent Weeks' }
]

books = [
	{ 'id': 1, 'name': 'Harry Potter and the Chamber of Secrets', 'authorId': 1 },
	{ 'id': 2, 'name': 'Harry Potter and the Prisoner of Azkaban', 'authorId': 1 },
	{ 'id': 3, 'name': 'Harry Potter and the Goblet of Fire', 'authorId': 1 },
	{ 'id': 4, 'name': 'The Fellowship of the Ring', 'authorId': 2 },
	{ 'id': 5, 'name': 'The Two Towers', 'authorId': 2 },
	{ 'id': 6, 'name': 'The Return of the King', 'authorId': 2 },
	{ 'id': 7, 'name': 'The Way of Shadows', 'authorId': 3 },
	{ 'id': 8, 'name': 'Beyond the Shadows', 'authorId': 3 }
]

'''
  This represents an author of a book.
'''
class AuthorType(ObjectType):
  # Author Fields
  id = Int(required=True)
  name = String(required=True)

  # Special Field book
  books = List(lambda:BookType)

  # Get the books for the given author
  def resolve_books(author, _):
    author_books = []

    for book in books:
      if book['authorId'] == author['id']:
        author_books.append(BookType(
          id = book['id'],
          name = book['name'],
          authorId = book['authorId']
        ))
    
    return author_books

'''
  This represents a book written by an author.
'''
class BookType(ObjectType):
  # BookType Fields
  id = Int(required=True)
  name = String(required=True)
  authorId = Int(required=True)

  # special Field author
  author = Field(lambda:AuthorType)

  # Get the author for the given book
  def resolve_author(book, _):
    author = [author for author in authors if book['authorId'] == author['id']]

    return AuthorType(
      id = int(author[0]['id']),
      name = author[0]['name']
    )

class Query(ObjectType):
  # Available queries defined as Fields
  book = Field(BookType, id=Int())
  books = List(BookType)

  author = Field(AuthorType, id=Int())
  authors = List(AuthorType)

  # Get book by ID
  def resolve_book(parent, _, id):
    return [book for book in books if book['id'] == id][0]

  # Get all books
  def resolve_books(parent, _):
    return books

  # Get author by ID
  def resolve_author(parent, _, id):
    return [author for author in authors if author['id'] == id][0]

  # Get all authors
  def resolve_authors(parent, _):
    return authors      

schema = Schema(query=Query)

# AWS Lambda handler
def lambda_handler(event, context):
    json_body = event['body']
    query = json.loads(json_body)['query']

    # Execute the GraphQL query
    response_body = str(json.dumps(schema.execute(query).data))

    return {
      'statusCode': 200,
      'headers': {response_type_key: response_type},
      'body': response_body
    }

# Start the dev server if executed locally
if environment_var_key not in os.environ or os.environ[environment_var_key] == local_environment:
  app = Flask(__name__)

  @app.route(graphql_route, methods=supported_methods)
  def index():
    '''
      Execute the GraphQL query and convert the response to a stringified JSON Object
    '''
    result = str(json.dumps(schema.execute(request.get_json()['query']).data))

    return Response(result, mimetype=response_type)

  app.run(host=host, port=port)