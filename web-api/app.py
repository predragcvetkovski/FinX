from flask import Flask
from pandas.io.json import json_normalize
from flask import request
import pandas as pd
import numpy as np
import urllib.request as urllib2
import json
from pandas.io.json import json_normalize
from sklearn.cluster import KMeans

app = Flask(__name__)
#available_year_end_balance = 20000

@app.route('/analysis', methods=['POST'])
def getFinancialAnalysis():
    req_data = request.json
    
    try:
        transactions_train = json_normalize(req_data['accounts'])
        available_year_end_balance = transactions_train['balances.available'].values[0]
        print('available bal',available_year_end_balance)
        inflationLoss = getInflationLoss(available_year_end_balance)
        summaryMetrics = getSummaryMetrics(inflationLoss, available_year_end_balance)
        #print('inflation', inflationLoss)
        #print('summary metrics', summaryMetrics)
        recommendations = getRecomendations(summaryMetrics['Total_money_available'])
        #print('recommendations', recommendations)
        dump = json.dumps({'summary': summaryMetrics, 'recommendations':  recommendations})
        return dump
    except Exception as ex:
        print("execptin", ex)
    return json.dumps({'summary': summaryMetrics, 'recommendations':  recommendations})
    #json.dumps(req_data)


def getInflationLoss(available_year_end_balance):
    try:
        initial_data = pd.ExcelFile("CPI.xlsx")
        df = initial_data.parse("CPI")
        df.rename(columns={'Value': 'inflation_rate', 'TIME': 'date'}, inplace=True)
        df = df[['date','inflation_rate']]
        df['available_year_end_balance'] = available_year_end_balance
        date_not = ['2017-07','2017-06','2017-05','2017-04','2017-03','2017-02','2017-01']
        df = df[~df.date.isin(date_not)]
        df['loss_after_inflation'] = (df['available_year_end_balance'] * df['inflation_rate'])/100
        #df['loss_after_inflation'] = (df['available_year_end_balance']*df['inflation_rate'])/100
        df[['year','month']] = df['date'].str.split('-',expand=True)
        inflation_loss_year_17 = df[df["year"] == "2017"]
        inflation_loss_year_18 = df[df["year"] == "2018"]
        inflation_loss_year_19 = df[df["year"] == "2019"]
        total_inflation_loss = inflation_loss_year_17['loss_after_inflation'].mean() + inflation_loss_year_18['loss_after_inflation'].mean() + inflation_loss_year_19['loss_after_inflation'].mean()
    except Exception as ex:
        print("execptin", ex)
    #return ​total_inflation_loss
    return  total_inflation_loss
def getSummaryMetrics(totalInflationLoss, available_year_end_balance):
    try:
        with open("transactions.txt") as train_file:
            dict_train = json.load(train_file)
            transactions = json_normalize(dict_train['transactions']['transactions'])
            transactions = transactions[['amount','category','date','name']]
            balances = json_normalize(dict_train['transactions']['accounts'])
            balances = balances[['balances.available','balances.current','name','official_name','subtype','type']]
            balances.rename(columns={'balances.available': 'balances_available', 'balances.current': 'balances_current'}, inplace=True)
        #total savings calculations
        typ = ['checking','savings']
        balances_f = balances[balances.subtype.isin(typ)]
        balances_f['balances_available'] = np.where(balances_f.name == 'Plaid Saving', 5000, balances_f['balances_available'])
        balances_f['balances_available'] = np.where(balances_f.name == 'Plaid Checking', 15000, balances_f['balances_available'])
        Total_money_available = available_year_end_balance
        Interest_rate = 0
        Money_earned_interest = ((Total_money_available * Interest_rate)/100)*20
        in_f = ['CREDIT CARD 3333 PAYMENT *//']
        transactions_f = transactions[transactions['name'].isin(in_f)]
        transactions_f['amount'][transactions_f['amount'] == 25]=10
        loss_credit_card_fee = transactions_f['amount']*24
        loss_credit_card_fee = loss_credit_card_fee.to_frame().reset_index()
        loss_credit_card_fee = loss_credit_card_fee['amount'].values[0]
        Total_loss = loss_credit_card_fee + totalInflationLoss
        #Total_loss = Total_loss.to_frame().reset_index()
        #Total_loss = Total_loss['amount'].values[0]
        loss_in_purchase_power = (Total_loss - Money_earned_interest)
        loss_in_purchase_power_percent = ((Total_loss - Money_earned_interest)/available_year_end_balance)*100
        projected_loss_in_purchase_power_in_10_yrs = loss_in_purchase_power*5
        return { 'loss_credit_card_fee': loss_credit_card_fee, 'loss_in_purchase_power': loss_in_purchase_power, 'Total_money_available': Total_money_available, 'Total_loss': Total_loss, 'loss_in_purchase_power_percent': loss_in_purchase_power_percent, 'projected_loss_in_purchase_power_in_10_yrs': projected_loss_in_purchase_power_in_10_yrs}
    except Exception as ex:
        print("summary execptin", ex)
    return { 'loss_credit_card_fee': loss_credit_card_fee, 'loss_in_purchase_power': loss_in_purchase_power, 'Total_money_available': Total_money_available, 'Total_loss': Total_loss, 'loss_in_purchase_power_percent': loss_in_purchase_power_percent, 'projected_loss_in_purchase_power_in_10_yrs': projected_loss_in_purchase_power_in_10_yrs}


def getRecomendations(totalMoneyAvailable):
    # train data for ML model
    try:
        train_data = pd.ExcelFile("Rates.xlsx")
        # checking ML model
        train_df_c = train_data.parse("Checking")
        train_df_c = train_df_c.drop(['Type'],axis = 1)
        train_df_c = pd.get_dummies(train_df_c)
        kmeans= KMeans(n_clusters=3)
        X_clustered=kmeans.fit_predict(train_df_c)
        train_df_c["cluster"] = X_clustered
        # checkings data extraction wrapper
        train_df_c_mean = train_df_c.groupby('cluster', as_index=False)['APY','MINIMUM DEPOSIT','Monthly Fee'].mean()
        cluster_num = train_df_c_mean['APY'].values.argmax()
        train_df_clus = train_df_c[train_df_c['cluster'] == cluster_num]
        train_df_clus = train_df_clus.sort_values('APY',ascending=False)
        train_df_clus = train_df_clus.iloc[0]
        train_df_clus = train_df_clus.to_frame().reset_index()
        train_df_clus.rename(columns={'index': 'att', 4: 'value'}, inplace=True)
        col_filter = ['APY','MINIMUM DEPOSIT','Monthly Fee']
        train_df_clus_sub_1 = train_df_clus[train_df_clus.att.isin(col_filter)]
        train_df_clus_sub_2 = train_df_clus[~train_df_clus.att.isin(col_filter)]
        train_df_clus_sub_2 = train_df_clus_sub_2[train_df_clus_sub_2['value'] == 1]
        train_df_clus_sub_2 = train_df_clus_sub_2[train_df_clus_sub_2['att'] != 'cluster'].drop(['value'], axis = 1)
        annual_interest_rate_c = train_df_clus_sub_1['value'].values[0]
        print(annual_interest_rate_c)
        # recommended checking calculations
        Money_earned_interest_c = (totalMoneyAvailable * annual_interest_rate_c)*2
        money_saved_from_fees = 240
        print(Money_earned_interest_c)
        Purchasing_power_through_checking = (annual_interest_rate_c - .014)*totalMoneyAvailable*2
        print(Purchasing_power_through_checking)
        Total_projected_savings_c = money_saved_from_fees + Purchasing_power_through_checking
        print(Total_projected_savings_c)
        #savings ML model
        train_df_s = train_data.parse("Savings")
        train_df_s = pd.get_dummies(train_df_s)
        kmeans= KMeans(n_clusters=3)
        Y_clustered=kmeans.fit_predict(train_df_s)
        train_df_s["cluster"] = Y_clustered
        # savings data extraction wrapper
        train_df_s_mean = train_df_s.groupby('cluster', as_index=False)['APY','MINIMUM DEPOSIT','Monthly Fee'].mean()
        cluster_num_1 = train_df_s_mean['APY'].values.argmax()
        train_df_clus_1 = train_df_s[train_df_s['cluster'] == cluster_num_1]
        train_df_clus_1 = train_df_clus_1.sort_values('APY',ascending=False)
        train_df_clus_1 = train_df_clus_1.iloc[0]
        train_df_clus_1 = train_df_clus_1.to_frame().reset_index()
        train_df_clus_1.rename(columns={'index': 'att', 6: 'value'}, inplace=True)
        col_filter = ['APY','MINIMUM DEPOSIT','Monthly Fee']
        train_df_clus_1_sub_1 = train_df_clus_1[train_df_clus_1.att.isin(col_filter)]
        train_df_clus_1_sub_2 = train_df_clus_1[~train_df_clus_1.att.isin(col_filter)]
        train_df_clus_1_sub_2 = train_df_clus_1_sub_2[train_df_clus_1_sub_2['value'] == 1]
        train_df_clus_1_sub_2 = train_df_clus_1_sub_2[train_df_clus_1_sub_2['att'] != 'cluster'].drop(['value'], axis = 1)
        print(train_df_clus_1_sub_1)
        print(train_df_clus_1_sub_2)
        annual_interest_rate_s = train_df_clus_1_sub_1['value'].values[0]
        print(annual_interest_rate_s)
        #recommended saving calculations
        Money_earned_interest_s = (totalMoneyAvailable * annual_interest_rate_s)*2
        money_saved_from_fees = 240
        print(Money_earned_interest_s)
        Purchasing_power_through_saving = (annual_interest_rate_s - .014)*totalMoneyAvailable*2
        print(Purchasing_power_through_saving)
        Total_projected_savings_s = money_saved_from_fees + Purchasing_power_through_saving
        print(Total_projected_savings_s)
    except Exception as ex:
        print("summary execptin", ex)
    return [{'gain': Total_projected_savings_c, 'purchasing_power': Purchasing_power_through_checking, 'service_fee': money_saved_from_fees}, {'gain': Total_projected_savings_s, 'purchasing_power': Purchasing_power_through_saving, 'service_fee': money_saved_from_fees}]
@app.route('/getanalysis')
def getAnalysis():
    with open("transactions.txt") as train_file:
        dict_train = json.load(train_file)
    return json.dumps(dict_train)

@app.route('/')
def hello_world():
    return 'Hello, Gaurav!'
if __name__ == '__main__':
    app.run()
