from flask import Flask, request
import json
import time
from hashlib import sha256
import requests


class Block:
    def __init__(self, index, transactions, timestamp, previous_hash, nonce=0):
        self.index = index
        self.transactions = transactions
        self.timestamp = timestamp
        self.previous_hash = previous_hash
        self.nonce = nonce

    def compute_hash(self):
        """
        A function that return the hash of the block contents.
        """
        block_string = json.dumps(self.__dict__, sort_keys=True)
        return sha256(block_string.encode()).hexdigest()


class DataChain:

    difficulty = 2

    def __init__(self):
        self.unconfirmed_transactions = []
        self.chain = []

    def create_genesis_block(self):        
        genesis_block = Block(0, [], time.time(), "0")
        genesis_block.hash = genesis_block.compute_hash()
        self.chain.append(genesis_block)

    @property
    def last_block(self):
        return self.chain[-1]

    def add_new_transaction(self, transaction):
        self.unconfirmed_transactions.append(transaction)

    def proof_of_work(self, block):        
        block.nonce = 0

        computed_hash = block.compute_hash()
        while not computed_hash.startswith('0' * DataChain.difficulty):
            block.nonce += 1
            computed_hash = block.compute_hash()

        return computed_hash

    def mine(self):
        if not self.unconfirmed_transactions:
            return False
        else:
            last_b = self.last_block

            new_block = Block(index=last_b.index + 1,
                              transactions=self.unconfirmed_transactions,
                              timestamp=time.time(),
                              previous_hash=last_b.hash,
                              nonce=0)

            proof = self.proof_of_work(new_block)
            self.add_block(new_block, proof)
            self.unconfirmed_transactions = []
            return new_block.index

    def add_block(self, block, proof):
        previous_hash = self.last_block.hash

        if previous_hash != block.previous_hash:
            return False

        block.hash = proof
        self.chain.append(block)
        return True


app = Flask(__name__)


datachain = DataChain()
datachain.create_genesis_block()

peers = set()


@app.route('/')
def hello_world():
    return 'Hello World'


@app.route('/new_transac', methods=['POST'])
def new_transac():
    patient = request.form['patient']
    doctor = request.form['doctor']
    symptoms = request.form['symptoms']
    medicines = request.form['medicines']
    visitNo = request.form['visit']
    tx_data = dict()
    tx_data["patient"] = patient
    tx_data["doctor"] = doctor
    tx_data["symptoms"] = symptoms
    tx_data["medicines"] = medicines
    tx_data["visit"] = visitNo

    tx_data["timestamp"] = time.time()

    datachain.add_new_transaction(tx_data)

    return "Success", 201


@app.route('/chain', methods=['GET'])
def get_chain():
    chain_data = []
    for block in datachain.chain:
        chain_data.append(block.__dict__)
    return json.dumps({"length": len(chain_data),
                       "chain": chain_data})


@app.route('/pending_tx')
def get_pending_tx():
    return json.dumps(datachain.unconfirmed_transactions)


@app.route('/mine')
def mine_unconfirmed_transactions():
    result = datachain.mine()
    return "Successful %s" % result


if __name__ == '__main__':
    app.run(debug=True)
