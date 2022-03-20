import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json'
import { MDBBtn, MDBCard, MDBCardBody, MDBCardImage, MDBCardTitle, MDBCardText } from 'mdb-react-ui-kit';

import './App.css'

class App extends Component {
    //queremos que la libreria web3 detecte nuestro metamask o cualquier proveedor de ether

    //para que renderice primero estas funciones
    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }
    async loadWeb3(){
        
        const provider= await detectEthereumProvider();
        if (provider) {
            // provider === window.ethereum
            console.log('wallet de ethereum conectado');
            window.web3 = new Web3(provider)
          } else {
            console.log('instalar un  wallet!!');
          }

    }

    async loadBlockchainData(){

        const web3 = window.web3
        const accounts = await web3.eth.requestAccounts()
        this.setState({account:accounts[0]})
        console.log(this.state.account)

        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]

        if (networkData){

            const abi = KryptoBird.abi;
            const address = networkData.address ;
            const contract = new web3.eth.Contract(abi, address)
            //console.log(contract)

            //agregamos el objeto contracto al json que tiene el abi y el address del contrato
            this.setState({contract})
            console.log(this.state.contract )

            //para saber el total supply de los mint ejecutados, agregamos el objeto totalSupply y lo llamamos
            //con las siguientes funciones
            const totalSupply= await contract.methods.totalSupply().call()
            this.setState({totalSupply})
          // console.log(this.state.totalSupply )

          //debemos de ccrear un array para tener un seguimiento de los tokens
          //Para cargar los nfts
          for(let i = 1; i <= totalSupply; i++) {
           const  KryptoBird = await contract.methods.kryptoBirdz(i - 1).call() //kryptoBirdz es el array que declaramos en el contrato
            this.setState({
                kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]   //los puntos (...) son el spread operator
            })
            }
           // console.log (this.state.kryptoBirdz)

        }else{
            window.alert('no se ejecuto el smart contract')
        }
    }

    //creamos la funcion mint, cuando minteamos lo que hacemos es mandar informacion y necesitamos especificar
    //la direccion

    mint =  (KryptoBird)=>{
        this.state.contract.methods.mint(KryptoBird).send({from:this.state.account})
        .once('receipt',()=>{
                this.setState({
                    kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird] 
                })
        })
    }

    //usamos el constructor porque estamos usano clases y no hooks, los props nos permiten pasar de un estado a otro
    constructor(props) {
        super(props);
        this.state = {
                account:'',
                contract: null,
                totalSupply:0,
                kryptoBirdz:[]
        }
    }
    render () {
           return (

            
            <div>
                {console.log(this.state.kryptoBirdz)}
                 <header>
                      <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
                           <div className="container-fluid">
                              <p className="navbar-brand">KryptoBird NFTs (Non Fungible Tokens)</p>
                              <div className="collapse navbar-collapse" id="navbarSupportedContent">
                              <ul className="navbar-nav ml-auto">
                                   <li className="nav-item">
                                  <p className="nav-link active"  >{this.state.account}</p>
                                   </li>
                              </ul>
                              </div>
                         </div>
                    </nav>
                </header>

                <main className=''>
                    <h1 className=' mt-5 mb-4 text-center'>MY NFT MARKETPLACE</h1>

                    <form className='main-form' onSubmit={(event)=>{
                        event.preventDefault()
                        const kryptoBird = this.kryptoBird.value
                        this.mint(kryptoBird)
                    }}>

                        <div className='row ' > 

                            <div className='col '>  
                                  
                                <input 
                                type='text'
                                placeholder='Archivo para mintear'
                                className='form-control '
                                ref={(input)=>this.kryptoBird=input}
                                />
                                
                            </div>

                            <div className='col ' > 
                                <input 
                                type='submit'
                                className='btn btn-primary '
                                value='MINT'
                                />
                            </div>
                        </div>
                    </form>

                </main>
                    <hr/>

                    <div className='row text-center'>
                        {this.state.kryptoBirdz.map((KryptoBird, index)=>{

                            return(
<div>
                                <div>
                                    <MDBCard className='token img' style={{maxWidth:'22rem'}}>
                                    <MDBCardImage className='tarjetaImagen' src={KryptoBird} position='top'  style={{marginRight:'4px'}}/>
                                        <MDBCardBody>
                                                <MDBCardTitle> kryptoBirdz </MDBCardTitle>
                                                <MDBCardText> Aves exoticas unicas en su coleccionAves exoticas unicas en su coleccionAves exoticas unicas en su coleccionAves exoticas unicas en su coleccionAves exoticas unicas en su coleccion</MDBCardText>
                                                <MDBBtn href={this.kryptoBird}>DOWNLOAD</MDBBtn>
                                        </MDBCardBody>
                                    </MDBCard>
                                </div>
                                </div>
                            )
                                
                        })}

                    </div>

             </div>
           ) 

    }

}

export default App;