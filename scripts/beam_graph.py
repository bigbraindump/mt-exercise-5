"""
Visualize impact of varying beam size on BLEU scores and time taken to complete a translation task.
"""

import matplotlib.pyplot as plt
import sys
import os

def visualize(model_name):
    base = f"/scratch/{os.getenv('USER')}/ex_05/mt-exercise-5"
    translations_sub = f"{base}/translations/{model_name}"

    # Load BLEU scores
    beam_sizes = []
    bleu_scores = []
    with open(f"{translations_sub}/bleu_scores.txt", 'r') as f:
        for line in f:
            if line.startswith("Beam size:") and "BLEU score:" in line:
                parts = line.strip().split(',')
                beam_size = int(parts[0].split(':')[1].strip())
                bleu_score_str = parts[1].split(':')[1].strip()
                if bleu_score_str:  # Ensure BLEU score is not empty
                    bleu_score = float(bleu_score_str.split()[0])
                    beam_sizes.append(beam_size)
                    bleu_scores.append(bleu_score)

    # Load times
    times = []
    beam_sizes_times = []  # To ensure beam sizes match times
    with open(f"{translations_sub}/time_taken.txt", 'r') as f:
        for line in f:
            if line.startswith("Beam size:") and "Time taken:" in line:
                parts = line.strip().split(',')
                beam_size = int(parts[0].split(':')[1].strip())
                time_taken = int(parts[1].split(':')[1].strip().replace('seconds', ''))
                beam_sizes_times.append(beam_size)
                times.append(time_taken)

    # Ensure that beam sizes for BLEU scores and times match
    if beam_sizes != beam_sizes_times:
        print("Warning: Beam sizes for BLEU scores and times do not match.")
        # Handle the mismatch appropriately, e.g., by trimming or aligning the lists

    # Plot BLEU scores
    plt.figure(figsize=(10, 6))
    plt.plot(beam_sizes, bleu_scores, marker='o')
    plt.title('Beam Size vs BLEU Score')
    plt.xlabel('Beam Size')
    plt.ylabel('BLEU Score')
    plt.grid(True)
    plt.savefig(f"{translations_sub}/beam_size_vs_bleu.png")
    plt.show()

    # Plot Time Taken
    plt.figure(figsize=(10, 6))
    plt.plot(beam_sizes_times, times, marker='o', color='red')
    plt.title('Beam Size vs Time Taken')
    plt.xlabel('Beam Size')
    plt.ylabel('Time Taken (seconds)')
    plt.grid(True)
    plt.savefig(f"{translations_sub}/beam_size_vs_time.png")
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python visualise.py <model_name>")
        sys.exit(1)
    
    model_name = sys.argv[1]
    visualize(model_name)