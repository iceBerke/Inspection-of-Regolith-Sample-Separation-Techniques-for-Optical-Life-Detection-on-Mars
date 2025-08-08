import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
s_30sec = [7.61, 5.94, 7.77, 6.98, 3.45, 10.00, 7.41, 7.69, 14.29]
s_1min = [6.02, 5.81, 8.64, 17.14, 11.58, 21.57, 5.56, 5.33, 5.45, 4.17, 4.23, 6.33, 10.64, 10.87, 13.64, 8.82, 3.13, 4.26, 19.35, 11.11, 32.20, 34.33, 23.94, 25.30, 35.54, 33.33, 36.90]
s_2min = [62.31, 69.47, 52.67, 26.98, 11.86, 16.22, 36.07, 36.17, 48.33, 45.54, 14.08, 7.69, 5.75, 32.61, 33.96, 30.61, 22.22, 41.38, 44.44]
s_5min = [20.00, 12.93, 13.22, 12.71, 13.39, 19.38, 13.82, 12.24, 14.84, 12.57, 66.67, 47.42, 64.15, 65.31, 50.00, 54.39, 59.52, 26.91]
s_10min = [0.00, 1.05, 0.00, 0.00, 0.00, 0.00, 2.63, 0.00, 0.00, 8.54, 
    7.89, 6.82, 9.46, 0.00, 1.61, 0.80, 1.38, 1.50, 3.70, 0.59, 
    1.70, 1.17, 6.82, 4.35, 7.91, 3.61, 7.87, 4.71, 0.00, 0.00, 
    0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
]
s_30min = [70.27, 31.25, 44.12, 54.05, 27.03, 10.39, 6.67, 20.25, 79.41, 20.00, 46.67, 46.43, 46.43, 44.00, 55.56, 47.06, 47.37]
s_60min = [58.33, 42.86, 33.33, 6.00, 1.72, 1.64, 2.98, 4.97, 4.49]
s_120min = [7.94, 7.41, 3.77, 12.50, 15.00, 19.30]

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Motile Cells (%)': s_30sec + s_1min + s_2min + s_5min + s_10min + s_30min + s_60min + s_120min,
    'Separation Technique': ['S-30sec'] * len(s_30sec) + ['S-1min'] * len(s_1min) + ['S-2min'] * len(s_2min) + ['S-5min'] * len(s_5min) + ['S-10min'] * len(s_10min) 
    + ['S-30min'] * len(s_30min) + ['S-60min'] * len(s_60min) + ['S-120min'] * len(s_120min)
})

print(df)

# Define custom colors for each group
colors_15 = [
    "#1f77b4",  # muted blue
    "#ff7f0e",  # safety orange
    "#2ca02c",  # cooked asparagus green
    "#d62728",  # brick red
    "#9467bd",  # muted purple
    "#8c564b",  # chestnut brown
    "#e377c2",  # raspberry yogurt pink
    "#7f7f7f",  # middle gray
    "#bcbd22",  # curry yellow-green
    "#17becf",  # blue-teal
    "#393b79",  # dark slate blue
    "#637939",  # olive green
    "#8c6d31",  # dark goldenrod
    "#843c39",  # dark red
    "#7b4173"   # dark orchid
]

my_colors = {'S-30sec': colors_15[0], 'S-1min': colors_15[14], 'S-2min': colors_15[1], 'S-5min': colors_15[13], 'S-10min': colors_15[2], 'S-30min': colors_15[12], 'S-60min': colors_15[3], 'S-120min': colors_15[11]}


plt.figure(figsize=(15, 10))
sns.boxplot(
    x='Separation Technique',
    y='Percentage of Motile Cells (%)',
    data=df,
    palette=my_colors,
    width=0.5,
    saturation=0.6  # Adjust this value (0 to 1) for desired color intensity
)
#sns.stripplot(
#    x='Group',
#    y='Value',
#    data=df,
#    color='black',
#    size=8,
#    jitter=True,
#    alpha=0.7
#)

plt.xlabel('Separation Technique', fontsize=18)  # x-axis label size
plt.ylabel('Percentage of Motile Cells (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

#plt.title('Preliminary experiments - Sonication')
plt.show()

print(f"sonication 30 seconds = {np.median(s_30sec)}")
print(f"sonication 1 minute = {np.median(s_1min)}")
print(f"sonication 2 minutes = {np.median(s_2min)}")
print(f"sonication 5 minutes = {np.median(s_5min)}")
print(f"sonication 10 minutes = {np.median(s_10min)}")
print(f"sonication 30 minutes = {np.median(s_30min)}")
print(f"sonication 60 minutes = {np.median(s_60min)}")
print(f"sonication 120 minutes = {np.median(s_120min)}")