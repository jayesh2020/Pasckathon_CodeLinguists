import axios from 'axios';
import { firestore } from '../firebase/firebase';

const predictionsHard = {
  'Acne and Rosacea Photos': {
    symtoms: [
      'Facial redness',
      'Swollen, red bumps',
      'Eye problems',
      'Enlarged nose'
    ],
    description: 'Persistent redness: Persistent facial redness might resemble a blush or sunburn that does not go away. Bumps and pimples: Small red solid bumps or pus-filled pimples often develop. Sometimes the bumps might resemble acne, but blackheads are absent. Burning or stinging might be present.'
  },
  'Eczema': {
    symtoms: [
      'Itch',
      'Dry, sensitive skin',
      'Inflame, discolored skin',
      'Rough, leathery or scaly patches of skin',
      'Oozing or crusting',
      'Hair loss'
    ],
    description: 'Atopic dermatitis usually develops in early childhood and is more common in people who have a family history of the condition. The main symptom is a rash that typically appears on the arms and behind the knees, but can also appear anywhere.Treatment includes avoiding soap and other irritants. Certain creams or ointments may also provide relief from the itching.'
  },
  'Hair Loss Photos Alopecia and other Hair Diseases': {
    symtoms: [
      'Gradual thinning on top of head',
      'Receding hairline',
      'Circular or patchy bald spots'
    ],
    description: 'Hair loss (alopecia) can affect just your scalp or your entire body, and it can be temporary or permanent. It can be the result of heredity, hormonal changes, medical conditions or a normal part of aging. Anyone can lose hair on their head, but it\'s more common in men.'
  },
  'Melanoma Skin Cancer Nevi and Moles': {
    symtoms: [
      'new spot on the skin',
      'ugly duckling sign',
      'A sore that doesn’t heal',
      'Redness or a new swelling beyond the border of the mole',
      'Change in sensation, such as itchiness, tenderness, or pain',
      'Family history of melanoma'
    ],
    description: 'Melanoma, also known as malignant melanoma, is a type of skin cancer that develops from the pigment-producing cells known as melanocytes. Melanomas typically occur in the skin but may rarely occur in the mouth, intestines or eye (uveal melanoma).'
  },
  'Nail Fungus and other Nail Disease': {
    symtoms: [
      'Thickened',
      'Whitish to yellow-brown discoloration',
      'Brittle, crumbly or ragged',
      'Distorted in shape',
      'Smelling slightly foul',
      'A dark color, caused by debris building up under your nail'
    ],
    description: 'A severe case of nail fungus can be painful and may cause permanent damage to your nails. And it may lead to other serious infections that spread beyond your feet if you have a suppressed immune system due to medication, diabetes or other conditions.'
  },
  'Tinea Ringworm Candidiasis and other Fungal Infections': {
    symtoms: [
      'Rash',
      'Redness and intense itching',
      'Cracked and sore skin',
      'Blisters and pustules'
    ],
    description: 'Tinea capitis is a skin infection or ringworm of the scalp caused by a fungus called dermatophytes (capitis comes from the Latin word for head). It mostly affects children.Tinea pedis or athlete’s foot is an infection that occurs on the feet, particularly between the toes (pedis is the Latin word for foot).'
  }
};

export const predictDisease = ({fireBaseUrl,uid,fd}) => async (dispatch) => {
  const formData = new FormData();
  formData.append('image', fd);
  try {

    const res = await axios.post('/predict', formData);
    const datei = new Date();
    const diseas = res.data.predictions[0];
    const desc = predictionsHard[`${diseas}`].description;
    console.log(datei);
    const data = {
      disease_name: diseas,
      description: desc,
      date: datei,
      fireBaseUrl
    };
    const docu = await firestore.doc(`Patients/${uid}`).collection('Tests').add(data);
    console.log(docu);
    console.log(desc);
    dispatch({
      type: 'PREDICT_SUCCESS',
      payload: {
        diseaseName: diseas,
        description: desc,
        fireBaseUrl,
        symtoms: predictionsHard[`${diseas}`].symtoms
      },
    });
  } catch (e) {
    console.log(e);
    dispatch({
      type: 'PREDICT_ERROR',
    });
  }
};
