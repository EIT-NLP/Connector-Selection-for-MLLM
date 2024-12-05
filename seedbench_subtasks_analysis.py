import json
import pandas as pd
import argparse

# Define mapping between question_type_id and name
question_type_mapping = {
    1: "Scene Understanding", 
    2: "Instance Identity",
    3: "Instance Attribute",
    4: "Instance Location", 
    5: "Instance Counting",
    6: "Spatial Relation",
    7: "Instance Interaction",
    8: "Visual Reasoning",
    9: "Text Recognition"
}

def analyze_seedbench(json_path):
    # Read JSON file
    with open(json_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # Extract log data
    logs = data['logs']
    
    # Initialize an empty dictionary to store statistics for each question_type_id
    results = {}
    
    # Process each log entry
    for log in logs:
        # Check if seed_image field exists
        if 'seed_image' not in log:
            continue  # Skip this record
        
        question_type_id = log['doc']['question_type_id']
        pred = log['seed_image']['pred']
        answer = log['seed_image']['answer']
        
        # Calculate score, 1 for correct, 0 for incorrect
        score = 1 if pred == answer else 0
        
        # Initialize or update statistics based on question_type_id
        if question_type_id not in results:
            results[question_type_id] = {'correct': 0, 'total': 0}
        
        results[question_type_id]['correct'] += score
        results[question_type_id]['total'] += 1
    
    # Convert results to DataFrame and calculate accuracy for each question_type_id
    df_results = pd.DataFrame([
        {
            'id': qid,
            'name': question_type_mapping.get(qid, "Unknown"),
            'accuracy': data['correct'] / data['total']
        }
        for qid, data in results.items()
    ])
    
    print("\nSeedBench Results:")
    print(df_results.to_string(index=False))

if __name__ == "__main__":
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description="Analyze SeedBench JSON Results.")
    parser.add_argument(
        "json_path", 
        type=str, 
        help="Path to the JSON file containing SeedBench results."
    )
    args = parser.parse_args()
    
    # Call analysis function
    analyze_seedbench(args.json_path)