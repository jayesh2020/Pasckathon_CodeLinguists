import React, { useState } from 'react';
import { setPersonalInfo } from '../../actions/info';
import { connect } from 'react-redux';
import { storage } from '../../firebase/firebase';

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
      {!toggler && <form>
        <div>
          <input
            type='text'
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </div>
        <div></div>
        <div>
          <input
            type='date'
            value={dob}
            onChange={(e) => setDOB(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={phoneNumber}
            onChange={(e) => setNumber(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={city}
            onChange={(e) => setCity(e.target.value)}
          />
        </div>
        <div>
          <select
            name='gender'
            value={gender}
            id='gender'
            onChange={(e) => setGender(e.target.value)}
          >
            <option value='Male'>Male</option>
            <option value='Female'>Female</option>
          </select>
        </div>
        <div>
          <input 
            type="file"
            onChange={handleImageAsFile}
          />
          <button onClick={handleFireBaseUpload}>Upload</button>
        </div>
        {imageAsUrl&&<img src={imageAsUrl.imgUrl} alt="image tag" />}
        <button onClick={onSubmit}>Next</button>
      </form>}
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
