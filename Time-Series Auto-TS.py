import numpy as np
import pandas as pd
from datetime import datetime
data = pd.read_excel(r'C:\Users\mahkam\Desktop\Time-Series Python\Sunstar-1 lit.xlsx')
model = AutoTS(
    forecast_length=6,
    frequency='infer',
    prediction_interval=0.95,
    ensemble=['simple', 'horizontal-min'],
    max_generations=15,
    num_validations=2,
    validation_method='seasonal 168',
    transformer_list='all',
    models_to_validate=0.2,
    drop_most_recent=1,
    n_jobs='auto',
)
date = data.iloc[:,2]
Date = date.apply(lambda x: datetime.strptime(x, '%Y/%m'))
model.fit(data, date_col='Date', value_col='Sell in', id_col=None)
prediction = model.predict()
forecast = prediction.forecast
print(forecast)
