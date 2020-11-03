import os
import argparse
import logging
import pyodbc
import csv

driver='FreeTDS'

parser = argparse.ArgumentParser()
parser.parse_known_args()
# Input file related arguments
parser.add_argument('-f', '--filename', help='that contains the data to import', default=os.environ.get('FK_FILENAME', default="test/dataset/10k_fakenames_fra.csv"))
# SQL related arguments
parser.add_argument('-S', '--server', help='target SQL server', default=os.environ.get('FK_SERVER', default="127.0.0.1"))
parser.add_argument('-P', '--port', help='listen port port of the SQL service', default=os.environ.get('FK_PORT', default="5000"))
parser.add_argument('-D', '--database', help='taget SQL database', default=os.environ.get('FK_DATBASE', default="cidb"))
parser.add_argument('-T', '--table', help='listen port port of the SQL service', default=os.environ.get('FK_TABLE', default="fakenames"))
parser.add_argument('-u', '--username', help='to authenticate to the SQL database', default=os.environ.get('FK_USERNAME', default="sa"))
parser.add_argument('-p', '--password', help='to access to the SQL database', default=os.environ.get('FK_PASSWORD', default="myPassword"))
# Logger arguments
parser.add_argument('-d', '--debug', help="Enable debug logging", action="store_true")
args, unknown = parser.parse_known_args()

logger = logging.getLogger('script')
ch = logging.StreamHandler()
if args.debug:
    logger.setLevel(logging.DEBUG)
    ch.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)
    ch.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

def connect():
    # Connect to database
    logger.info('Connecting to server "{0}:{1}" database "{2}"'.format(args.server, args.port, args.database))
    conn = pyodbc.connect(driver=driver, server=args.server, database=args.database ,port=args.port, uid=args.username, pwd=args.password)
    return conn


def create_table(dbconn, tablename):
    logger.info('Check if table "{0}" exists'.format(tablename))
    
    cursor = dbconn.cursor()
    
    cursor.execute("""
        select name
        from sysobjects
        where type = "U" and name = '{0}'
        """.format(tablename)
    )
    
    try: 
        cursor.fetchone()[0]

        logger.info('Table "{0}" already exists.'.format(tablename))
    except TypeError as e:
        logger.info('Table "{0}" does not exists. Creating...'.format(tablename))

        cursor.execute("""
        CREATE TABLE {0} (
        number numeric (10,0) identity primary key,
        gender nvarchar(6) not null,
        nameset nvarchar(25) not null,
        title nvarchar(6) not null,
        givenname nvarchar(20) not null,
        middleinitial nvarchar(1) not null,
        surname nvarchar(23) not null,
        streetaddress nvarchar(100) not null,
        city nvarchar(100) not null,
        state nvarchar(22) not null,
        statefull nvarchar(100) not null,
        zipcode nvarchar(15) not null,
        country nvarchar(2) not null,
        countryfull nvarchar(100) not null,
        emailaddress nvarchar(100) not null,
        username varchar(25) not null,
        password nvarchar(25) not null,
        browseruseragent nvarchar(255) not null,
        telephonenumber nvarchar(25) not null,
        telephonecountrycode int not null,
        maidenname nvarchar(23) not null,
        birthday datetime not null,
        age int not null,
        tropicalzodiac nvarchar(11) not null,
        cctype nvarchar(10) not null,
        ccnumber nvarchar(16) not null,
        cvv2 nvarchar(3) not null,
        ccexpires nvarchar(10) not null,
        nationalid nvarchar(20) not null,
        upstracking nvarchar(24) not null,
        westernunionmtcn nchar(10) not null,
        moneygrammtcn nchar(8) not null,
        color nvarchar(6) not null,
        occupation nvarchar(70) not null,
        company nvarchar(70) not null,
        vehicle nvarchar(255) not null,
        domain nvarchar(70) not null,
        bloodtype nvarchar(3) not null,
        pounds decimal(5,1) not null,
        kilograms decimal(5,1) not null,
        feetinches nvarchar(6) not null,
        centimeters smallint not null,
        guid nvarchar(36) not null,
        latitude numeric(10,8) not null,
        longitude numeric(11,8) not null
        )
        """.format(tablename))

        dbconn.commit()
        

def import_piped_data(dbconn, tablename, filename):
    logger.info('Load data from file "{0}" to table "{1}"'.format(filename, tablename))

    cursor = dbconn.cursor()

    with open(file=filename, mode='r', newline=None ) as csvfile:
        csvfile.readline()
        spamreader = csv.reader(csvfile, delimiter='|', quotechar='"')
        
        for row in spamreader:
            cursor.execute("""
                insert into {0}
                values ({1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9},
                        {10}, {11}, {12}, {13}, {14}, {15}, {16}, {17}, {18}, {19},
                        {20}, {21}, {22}, {23}, {24}, {25}, {26}, {27}, {28}, {29},
                        {30}, {31}, {32}, {33}, {34}, {35}, {36}, {37}, {38}, {39},
                        {40}, {41}, {42}, {43}, {44}
                       )
                """.format(tablename,
                    row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9],
                    row[10], row[11], row[12], row[13], row[14], row[15], row[16], row[17], row[18], row[19],
                    row[20], row[21], row[22], row[23], row[24], row[25], row[26], row[27], row[28], row[29],
                    row[30], row[31], row[32], row[33], row[34], row[35], row[36], row[37], row[38], row[39],
                    row[40], row[41], row[42], row[43], row[44]
                    )
                )
            dbconn.commit()
            # print(row)


def import_csv_data(dbconn, tablename, filename):
    logger.info('Load data from file "{0}" to table "{1}"'.format(filename, tablename))
    
    # Table configuration
    cursor = dbconn.cursor()
    cursor.execute('SET IDENTITY_INSERT {0} ON'.format(tablename))
    cursor.commit()

    with open (file=filename, mode='r', newline=None, encoding='utf-8-sig') as f:
        reader = csv.reader(f)
        columns = next(reader) 
        query = 'insert into ' + tablename + '({0}) values ({1})'
        query = query.format(','.join(columns), ','.join('?' * len(columns))).lower()
        query = query.replace('mothersmaiden','maidenname')
        query = query.replace('ups','upstracking')

        for data in reader:
            cursor = dbconn.cursor()
        
            data[0] = int(data[0])
            data[8] = data[8].replace('Ÿ','Y')
            data[19] = int(data[19])
            data[22] = int(data[22])
            data[38] = float(data[38])
            data[39] = float(data[39])
            data[41] = int(data[41])
            data[43] = float(data[43])
            data[44] = float(data[44])
            cursor.execute(query, data)
            
            cursor.commit()


def handle(event, context):
    dbconn = connect()
    create_table(dbconn=dbconn, tablename=args.table)
    # import_piped_data(dbconn=dbconn, tablename=args.table, filename=args.filename)
    import_csv_data(dbconn=dbconn, tablename=args.table,filename=args.filename)


if __name__ == '__main__':
    event = {}
    context = {}
    handle(event, context)