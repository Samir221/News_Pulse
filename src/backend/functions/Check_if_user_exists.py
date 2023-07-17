from flask import jsonify
from google.cloud import firestore

def check_user_id(request):
    user_id = request.args.get('userId')

    # Initialize Firestore client
    db = firestore.Client()

    # Query the "users" collection
    users_ref = db.collection('users')
    query = users_ref.where('UserID', '==', user_id).limit(1).get()

    # Check if the user ID exists
    user_id_exists = len(query) > 0