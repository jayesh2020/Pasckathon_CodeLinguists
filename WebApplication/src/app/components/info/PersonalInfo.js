import React, { useState } from 'react';
import { setPersonalInfo } from '../../actions/info';
import { connect } from 'react-redux';
import { storage } from '../../firebase/firebase';
import { MDBDatePickerV5 } from 'mdbreact';
import { Button } from 'react-bootstrap';
import { Container } from '@material-ui/core';

const PersonalInfo = ({ history,setPersonalInfo }) => {
  const [toggler,setToggler] = useState(false);
  const [dob, setDOB] = useState('');
  const [phoneNumber, setNumber] = useState('');
  const [city, setCity] = useState('');
  const [gender, setGender] = useState('Male');
  const [role,setRole] = useState('');
  const [error,setError] = useState('');
  const [name,setName] = useState('');
  const [profilePicture, setProfilePicture] = useState('');
  const allInputs = {imgUrl: ''}
  const [imageAsFile, setImageAsFile] = useState('')
  const [imageAsUrl, setImageAsUrl] = useState(allInputs)

  const onSubmit = (e) => {
    e.preventDefault();
    const personal = {
      dateOfBirth:dob,
      phoneNumber,
      city,
      gender,
      name,
      profilePic:imageAsUrl.imgUrl
    };
    setToggler(true);
    setPersonalInfo(personal);
    setDOB('');
    setGender('Male');
    setCity('');
    setImageAsFile('');
    setImageAsUrl('');
  };

  const onChangeValue =( e) => {
    e.preventDefault();
    setRole(e.target.value);
  }

  const handleImageAsFile = (e) => {
    const image = e.target.files[0]
    setImageAsFile(imageFile => (image))
  }

  const handleFireBaseUpload = e => {
    e.preventDefault()
    console.log('start of upload')
    // async magic goes here...
    if(imageAsFile === '') {
      console.error(`not an image, the image file is a ${typeof(imageAsFile)}`)
    }
    const uploadTask = storage.ref(`/images/${imageAsFile.name}`).put(imageAsFile)
    //initiates the firebase side uploading 
    uploadTask.on('state_changed', 
    (snapShot) => {
      //takes a snap shot of the process as it is happening
      console.log(snapShot)
    }, (err) => {
      //catches the errors
      console.log(err)
    }, () => {
      // gets the functions from storage refences the image storage in firebase by the children
      // gets the download url then sets the image from firebase as the value for the imgUrl key:
      storage.ref('images').child(imageAsFile.name).getDownloadURL()
      .then(fireBaseUrl => {
        setImageAsUrl(prevObject => ({...prevObject, imgUrl: fireBaseUrl}))
      })
    })
  }

  const onRoleSubmit = (e) => {
    e.preventDefault();
    if(role == 'Patient'){
      history.push('/patientsinfo');
    } else if(role=='Doctor') {
      history.push('/doctorsinfo');
    } else {
      setTimeout(setError('Please define role'),2000);
      setError('');
    }
  } 
  return (
    <div>
      {error && <p>{error}</p>}
      {!toggler && 
        <Container style={{maxWidth:600, marginTop:20}}>
        <form>
        <div class="form-group row">
          <label for="name" class="col-sm-3 col-form-label">Name</label>
          <div class="col-sm-9">
            <input type="text" name="name" value={name} onChange={(e) => setName(e.target.value)} class="form-control" id="name" />
          </div>
        </div>
        
        <div className="form-group row">
        <label for="date" class="col-sm-3 col-form-label">Date of Birth</label>
        <div className="col-sm-9">
          <input
            type='date'
            name="date"
            id="date"
            className="form-control"
            value={dob}
            onChange={(e) => setDOB(e.target.value)}
          />
        </div>
        </div>
        <div class="form-group row">
          <label for="phone" class="col-sm-3 col-form-label">Phone Number</label>
          <div className="col-sm-9">
          <input
            name="phone"
            type='text'
            id="phone"
            className="form-control"
            value={phoneNumber}
            onChange={(e) => setNumber(e.target.value)}
          />
          </div>
        </div>
        <div class="form-group row">
          <label for="city" class="col-sm-3 col-form-label">City</label>
          <div className="col-sm-9">
          <input
            name="city"
            type='text'
            value={city}
            className="form-control"
            onChange={(e) => setCity(e.target.value)}
          />
          </div>
        </div>
        
        <div class="form-group row">
          <label for="exampleFormControlSelect1" class="col-sm-3 col-form-label">Gender</label>
          <div className="col-sm-9">
          <select class="form-control" id="exampleFormControlSelect1" value={gender} onChange={(e) => setGender(e.target.value)}>
            <option value='Male'>Male</option>
            <option value='Female'>Female</option>
          </select>
          </div>
        </div>
        <div class="form-group row custom-file" style={{marginTop:20}}>
          <label className="col-sm-3 col-form-label">Profile Pic</label>
          <div className="col-sm-9" name="fileInput" id="fileInput">
            <label class="custom-file-label" for="customFileLang">Select File</label>
              <input type="file" onChange={handleImageAsFile} class="custom-file-input form-control" id="customFileLang"  />
          </div>
            {imageAsFile && <button type="button" className="btn btn-warning" onClick={handleFireBaseUpload}>Upload</button>}
        </div>
        
        {imageAsUrl&&<img src={imageAsUrl.imgUrl} alt="image tag" />}
        <button type="button" className="btn btn-primary" onClick={onSubmit}>Next</button>
      </form>
      </Container>}
      {toggler && <div>
        <h3>Define your role</h3>
        <div onChange={onChangeValue} required>
          <input type="radio" value="Patient" name="role" /> Patient
          <input type="radio" value="Doctor" name="role" /> Doctor
        </div>
        <button onClick={onRoleSubmit}>Submit</button>
      </div>}
    </div>
  );
};

const mapDispatchToProps = (dispatch) => ({
  setPersonalInfo: (personal) => dispatch(setPersonalInfo(personal))
});

export default connect(null,mapDispatchToProps)(PersonalInfo);
