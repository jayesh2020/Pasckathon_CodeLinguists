import React, { useState } from 'react';
import { connect } from 'react-redux';
import { predictDisease } from '../../actions/predict';
const ImageTest = ({ history,predictDisease, predict }) => {
  const [state, setState] = useState(null);
  const [toggler, setToggler] = useState(false);
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
    predictDisease(state.selectedFile);
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
          {state && <img src={state.file} height='50%' width='50%' />}
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
const mapStateToProps = (state) => ({ predict: state.predict });
const mapDispatchToProps = (dispatch) => ({
  predictDisease: (data) => dispatch(predictDisease(data)),
});
export default connect(mapStateToProps, mapDispatchToProps)(ImageTest);
