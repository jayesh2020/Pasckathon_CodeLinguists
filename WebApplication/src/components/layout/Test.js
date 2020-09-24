import React, { useState } from 'react';
import { connect } from 'react-redux';
import { predictDisease } from '../../actions/predict';
import { storage } from '../../firebase/firebase';
import { Button,Col,Image,Row,Card } from 'react-bootstrap';

const ImageTest = ({ history,predictDisease, predict,auth }) => {
  const [state, setState] = useState(null);
  const [toggler, setToggler] = useState(false);
  const [fireURL,setFireURL] = useState('');
  const allInputs = {imgUrl: ''}

  const [imageAsUrl, setImageAsUrl] = useState(allInputs)

  const handleChange = (event) => {
    setState({
      file: URL.createObjectURL(event.target.files[0]),
      selectedFile: event.target.files[0],
    });
  };
  const discardChange = () => {
    setState(null);
  };
  const imageUpload = () => {
    console.log('start of upload')
    const {selectedFile} = state;
    if(selectedFile === '') {
      console.error(`not an image, the image file is a ${typeof(selectedFile)}`)
    }
    const uploadTask = storage.ref(`/images/${selectedFile.name}`).put(selectedFile)
    uploadTask.on('state_changed', 
    (snapShot) => {
      console.log(snapShot)
    }, (err) => {
      console.log(err)
    }, () => {
      storage.ref('images').child(selectedFile.name).getDownloadURL()
      .then(fireBaseUrl => {
        console.log(fireBaseUrl);
        //setFireURL(fireBaseUrl);
        predictDisease({fireBaseUrl,uid:auth.uid,fd:state.selectedFile});
      });
    });
    console.log(fireURL);
    console.log(imageAsUrl);
    //predictDisease({fire: fireURL.imgUrl,uid:auth.uid,fd:state.selectedFile});
    //setState(null);
    setToggler(true);
  };

  const handleClick = () => {
    history.push('/doctorsearch');
  }
  return (
    <div style={{backgroundColor: "#cccccc",backgroundImage: "linear-gradient(orange, white)",width:"100%",height:"80vh"}}>
      {!toggler && (
        <div>
          <Row>
          <Col lg={4}></Col>
          <Col lg={4}>
            <div class="custom-file" style={{marginTop:20}}>
              <input type="file" onChange={handleChange} class="custom-file-input" id="customFileLang"  />
              <label class="custom-file-label" for="customFileLang">{state && state.selectedFile.name || 'Select File'}</label>
            </div>
          </Col>
          </Row>
          <br></br>
          <Row>
          <Col lg={4}></Col>
          <Col lg={4}>
          {state && 
            <Image src={state.file} center="true" rounded />
          }          
          </Col>
          </Row>
          
          <div className="mb-2">
            {!!state && <Button onClick={discardChange} variant="black text-white" size="lg">
              Discard
            </Button>}
            {state && <Button onClick={imageUpload} variant="orange" size="lg">
              Upload
            </Button>}
          </div>
        </div>
      )}
      {toggler && (
        <div style={{marginLeft:"auto", marginRight:"auto"}}>
        <Card style={{marginLeft:"auto", marginRight:"auto", marginTop:"2rem", width: '30rem' }}>
          <Card.Img variant="top" src={state.file} />
          <Card.Body>
            <Card.Title>{predict.diseaseName}</Card.Title>
            <Card.Text>
              {predict.diseaseName && <p>Eczema is a term for a group of conditions that make your skin inflamed or irritated. The most common type is atopic dermatitis or atopic eczema. “Atopic” refers to a person’s tendency to get allergic conditions such as asthma and hay fever.</p>}
            </Card.Text>
            {predict.diseaseName && <Button variant="orange text-white text-bold" onClick={handleClick}>Consult a doctor</Button>}
          </Card.Body>
        </Card>
        </div>
      )}
    </div>
  );
};
const mapStateToProps = (state) => ({ auth: state.auth,predict: state.predict });
const mapDispatchToProps = (dispatch) => ({
  predictDisease: (data) => dispatch(predictDisease(data)),
});
export default connect(mapStateToProps, mapDispatchToProps)(ImageTest);
