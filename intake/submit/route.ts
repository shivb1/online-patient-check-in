import { NextResponse } from "next/server";

export async function POST(req: Request) {
  const data = await req.json();

  console.log("📥 Intake-Daten angekommen:", data);

  return NextResponse.json({ ok: true });
}


//import { NextResponse } from "next/server";
//import { pool } from "@/app/lib/db";

//export async function POST(req: Request) {
  //const data = await req.json();

  //const client = await pool.connect();
  //try {
    //await client.query("BEGIN");

    //const patientRes = await client.query(
    //  `INSERT INTO patient (first_name, last_name, birth_date, ahv_number)
    //   VALUES ($1,$2,$3,$4) RETURNING id`,
     // [data.firstName, data.lastName, data.birthDate, data.ahvNumber]
   // );

    //const patientId = patientRes.rows[0].id;

   //await client.query(
    //  `INSERT INTO patient_contact
     //  (patient_id, address, zip, city, phone, phone_private, email)
     //  VALUES ($1,$2,$3,$4,$5,$6,$7)`,
     // [
      //  patientId,
      //  data.address,
      //  data.zip,
      //  data.city,
       // data.phone,
      //  data.phonePrivate,
      //  data.email,
    //  ]
   // );

    //const intakeRes = await client.query(
   //   `INSERT INTO intake (patient_id, status)
 //      VALUES ($1,'submitted') RETURNING id`,
 //     [patientId]
 //   );

 //   await client.query(
  //    `INSERT INTO medical_history (...) VALUES (...)`
  //  );

  //  await client.query("COMMIT");
 //   return NextResponse.json({ ok: true });
 // } catch (e) {
 //   await client.query("ROLLBACK");
 //   throw e;
 // } finally {
//    client.release();
 // }
//}