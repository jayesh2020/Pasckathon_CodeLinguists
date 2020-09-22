import React,{ useState } from 'react'
import { connect } from 'react-redux';
import { setQuest } from '../../actions/doctorSearch';

const Questionaire = ({ setQuest }) => {
    const [duration,setDuration] = useState('');
    const [severity,setSeverity] = useState('');
    const [timeOf,setTimeOf] = useState([]);
    const [prevMed,setPrevMed] = useState('');
    const [bodyPart,setBodyPart] = useState('');
    const handleInputChange = (event) => {
        const target = event.target;
        const value = target.type === 'checkbox' ? target.checked : target.value;
        const name = target.name;
        setTimeOf([...timeOf,event.target.value]);
    }
    return (
        <div>
            <form>
                <div>
                    <label htmlFor="duration">Duration for which you are facing issues?</label>
                    <input type="text" name="duration" value={duration} onChange={(e) => setDuration(e.target.value)} />
                </div>
                <div>
                    <label htmlFor="severity">What is the severity of disease?</label>
                    <input type="text" name="severity" value={severity} onChange={(e) => setSeverity(e.target.value)} />
                </div>
                <div>
                    <label htmlFor="prevMed">Any previous medications</label>
                    <textarea name="prevMed" value={prevMed} onChange={(e) => setPrevMed(e.target.value)}></textarea>
                </div>
                <div>
                    <label htmlFor="timeOf">Time of day you face problems</label>
                    <input name="timeOf" value={timeOf} onChange={(e) => setTimeOf(e.target.value)}></input>
                </div>
                <div>
                    <label htmlFor="bodyPart">Which part of body</label>
                    <input name="bodyPart" value={bodyPart} onChange={(e) => setBodyPart(e.target.value)}></input>
                </div>
                <button onClick={(e) => {
                    e.preventDefault();
                    setQuest({duration,severity,prevMed,timeOf,bodyPart});
                }}>Submit</button>
            </form>
        </div>
    )
}

export default connect(null,{ setQuest })(Questionaire);