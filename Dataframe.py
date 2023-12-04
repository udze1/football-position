#%%
import numpy as np
import pandas as pd
import seaborn as sns

df = pd.read_csv("male_players.csv")

df.isnull().sum()

df.drop(columns=['player_id', 'player_url', 'fifa_update', 'update_as_of', 'long_name', 'player_positions', 'overall', 'potential',
'value_eur', 'wage_eur', 'age', 'dob', 'height_cm', 'weight_kg', 'club_team_id', 'league_id', 'league_name', 'league_level', 'club_jersey_number',
'club_loaned_from', 'club_joined_date', 'club_contract_valid_until_year', 'nationality_id', 'nationality_name',
'nation_team_id', 'nation_position', 'nation_jersey_number', 'preferred_foot', 'weak_foot', 'skill_moves', 'international_reputation',
'work_rate', 'body_type', 'real_face', 'release_clause_eur', 'player_tags', 'player_traits', 'goalkeeping_diving', 'goalkeeping_handling',
'goalkeeping_kicking', 'goalkeeping_positioning', 'goalkeeping_reflexes', 'goalkeeping_speed', 'ls', 'st', 'rs', 'lw', 'lf', 'cf', 'rf','rw', 'lam', 'cam', 'ram', 'lm', 'lcm',
'cm', 'rcm', 'rm', 'lwb', 'ldm', 'cdm', 'rdm', 'rwb', 'lb', 'lcb', 'cb', 'rcb', 'rb', 'gk', 'pace', 'shooting', 'passing', 'dribbling', 'defending', 'physic'], inplace=True)

df = df[df['fifa_version'] == 24]
#%% 

df = df.dropna()

df.isnull().sum()

df.club_position.value_counts()

df = df[df['club_position'] != 'SUB']
df = df[df['club_position'] != 'RES']
#%% 
df.head()

df["club_position"].value_counts()
#%%

Attacker = dict.fromkeys(['ST', 'LW', 'RW', 'LS', 'RS', 'CF', 'RF', 'LF'], 'Attacker')
Midfielder = dict.fromkeys(['CM', 'RM', 'LM', 'CAM', 'CDM', 'LCM', 'RCM', 'RDM', 'LDM', 'RAM', 'LAM'], 'Midfielder')
Defender = dict.fromkeys(['CB', 'LB', 'RB', 'RCB', 'LCB', 'RWB', 'LWB' ], 'Defender')
df["club_position"].replace('GK', 'Goalkeeper', inplace=True)
df["club_position"].replace(Attacker, inplace=True)
df["club_position"].replace(Midfielder, inplace=True)
df["club_position"].replace(Defender, inplace=True)

df.duplicated('short_name').sum()

df.to_csv('MLdataset.csv', index=False)
