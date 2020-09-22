import React, { useState } from 'react';
import { connect } from 'react-redux';
import { predictDisease } from '../../actions/predict';
import { storage } from '../../firebase/firebase';

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
    setState(null);
    setToggler(true);
  };

  const handleClick = () => {
    history.push('/doctorsearch');
  }
  return (
    <div>
      {!toggler && (
        <div>
          <input type='file' onChange={handleChange} />
          {state && <img src={state.file} height='30%' width='30%' />}
          {!!state && <button onClick={discardChange}>Discard</button>}
          {state && <button onClick={imageUpload}>Upload</button>}
        </div>
      )}
      {toggler && (
        <div>
          <p>{predict.diseaseName}</p>
          <p>{predict.description}</p>
          <button onClick={handleClick}>Consult a doctor</button>
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
