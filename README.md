# AttendEase: BLE based Attendance System
AttendEase is a BLE-based mobile app designed to streamline attendance tracking for educators and students. It uses Bluetooth Low Energy (BLE) technology to automatically mark attendance by detecting students' proximity to the classroom. AttendEase simplifies attendance, reduces errors, and provides real-time data via export.

<h2>Table of Contents</h2>
<ul>
  <li> <a href = "#About"> About </a></li>
  <ul>
   <li><a href="#wa"> What is AttendEase? </a></li> 
   <li><a href="#features"> Features </a></li> 
  </ul>
  <li> <a href = "#getting_started"> Getting Started </a></li>
  <ul>
   <li><a href="#prerequisites"> Prerequisites </a></li> 
   <li><a href="#installation"> Installation </a></li> 
  </ul>
  <li> <a href = "#tech_used"> TechStack used </a></li>
  <li> <a href = "#screenshots"> Screenshots </a></li>
  <li> <a href = "#Attendance Process"> Attendance Process </a></li>
  <li> <a href = "#team"> Team </a></li>
</ul>

<section id = "About">
  <h2> About </h2>
  <h3 id = "wa"> What is AttendEase? </h3>
    In modern educational settings, efficient attendance management is crucial. Traditional methods can be time-consuming and prone to errors. AttendEase leverages BLE technology to automate the attendance process, ensuring that students are marked present only when they're physically in the classroom. With real-time data syncing via Firebase, AttendEase minimizes manual work, offering a seamless experience for both teachers and students.

  The app supports a user-friendly interface, making it easy for educators to manage attendance records and students to monitor their eligibility for exams. Security is paramount, and all data is securely stored and transmitted through Firebase's robust security features.

  <h3 id = "features"> Features </h3>
<ul>
    <li><strong>User-Friendly Interface</strong>
        <ul>
            <li>Clean Design provides a visually appealing layout that minimizes clutter.</li>
            <li>Intuitive Navigation offers simple paths to help users quickly find what they need.</li>
        </ul>
    </li>
  <br>
    <li><strong>Course Management</strong>
        <ul>
            <li>Efficient Course Creation allows teachers to easily update course details in compliance with NEP guidelines.</li>
            <li>Unique Session Creation enables the creation of distinct sessions for organized learning.</li>
        </ul>
    </li>
  <br>
    <li><strong>Class-Wise Attendance Tracking</strong>
        <ul>
            <li>Class-Specific Records maintain separate logs for each class to ensure clarity.</li>
            <li>Historical Data Access provides quick access to past attendance records for review.</li>
        </ul>
    </li>
  <br>
    <li><strong>Bluetooth BLE Attendance System</strong>
        <ul>
            <li>Proximity-Based Attendance automatically marks students present when within BLE range.</li>
            <li>Session-Specific Signals use unique identifiers for accurate attendance tracking.</li>
        </ul>
    </li>
  <br>
    <li><strong>Automatic Attendance Updates</strong>
        <ul>
            <li>Real-Time Marking updates attendance immediately to reflect student presence.</li>
            <li>Immediate Data Availability ensures records are accessible instantly after marking.</li>
        </ul>
    </li>
  <br>
    <li><strong>Manual Attendance Editing</strong>
        <ul>
            <li>Flexible Editing Options allow teachers to adjust attendance records as needed.</li>
            <li>Change Log Tracking logs all edits to maintain an accurate record of changes.</li>
        </ul>
    </li>
  <br>
    <li><strong>Real-Time Attendance Updation</strong>
        <ul>
            <li>Instant Feedback provides notifications of attendance status immediately.</li>
            <li>User Dashboard Updates reflect attendance data in student dashboards instantly.</li>
        </ul>
    </li>
  <br>
    <li><strong>Export Attendance Data</strong>
        <ul>
            <li>Excel Export enables attendance data to be exported in Excel format for reporting.</li>
            <li>Simple Access allows teachers to quickly download records without complex procedures.</li>
        </ul>
    </li>
  <br>
    <li><strong>Delegation</strong>
        <ul>
            <li>Temporary Role Assignment allows teachers to assign attendance duties during busy periods.</li>
            <li>Access Control ensures that delegated teachers have the necessary permissions to manage attendance effectively.</li>
        </ul>
    </li>
</ul>
</section>


<section id = "getting_started">
  <h2> Getting Started </h2>
  <h3 id = "prerequisites"> Prerequisites </h3>
  <p>Before you begin, ensure that you have the following prerequisites installed on your development environment:</p>

<ul>
  <li>
    <strong>Flutter with Android Studio</strong>: To build and run the Attendease application, you must have Flutter and Android Studio installed. Follow the installation instructions for Flutter and Android Studio based on your operating system:
    <ul>
      <li><a href="https://flutter.dev/docs/get-started/install">Flutter Installation Guide</a></li>
      <li><a href="https://developer.android.com/studio">Android Studio Installation Guide</a></li>
    </ul>
  </li>
  <li>
    <strong>Android SDK</strong>: Android Studio usually comes with the Android SDK, but it's essential to ensure it's correctly installed and configured. Android SDK is necessary for building and running Android applications with Flutter. Make sure all the required paths regarding Android SDK are added to PATH in the environment variables of your PC.
  </li>
</ul>

<p>After installing Flutter and Android Studio, it's highly recommended to run the following command to check for any additional requirements or corrections in your Flutter environment:</p>
<pre><code>flutter doctor</code></pre>  
  <h3 id = "installation"> Installation </h3>
  <h3>Running the Server:</h3>
<ul>
  <li>
    <p><strong>Clone the Repository</strong>: Begin by cloning the cli-Mate repository from GitHub to your local machine. This step ensures you have the server's source code.</p>
    <pre><code>git clone https://github.com/PranavRao30/AttendEase.git</code></pre>
  </li>
</ul>

<h3>Compiling the App:</h3>
<ul>
  <li>
    <strong>Navigate to App Directory</strong>: If you haven't already, navigate to the directory containing the Flutter app code. In this case, it appears to be in the "AttendEase" directory.
  </li>
  <li>
   <p> <strong>Get Dependencies</strong>: Run the below command to fetch and install the necessary Flutter dependencies for the app. This step ensures that your app has access to required packages.</p>
    <pre><code>flutter pub get</code></pre>
  </li>
  <li>
    <strong>Connect Android Device or Emulator</strong>: Ensure your Android device is connected to your computer via USB, and USB debugging is enabled in developer mode. Alternatively, you can use an emulator to test the app.
  </li>
  <li>
    <p><strong>Launch the App</strong>: Run the below command after selecting the target device or emulator. This command will install and launch the app on the specified device.</p>
    <pre><code>flutter run</code></pre>
  </li>
</ul>

  
</section>


<section id = "tech_used">
  <h2> TechStack - Built with
    <img src="https://cdn.icon-icons.com/icons2/2530/PNG/512/flutter_button_icon_151957.png" alt="Flutter" height="20" style="vertical-align: middle; filter: none;"/>
   
  <img src="https://cdn.icon-icons.com/icons2/2530/PNG/512/dart_colour_button_icon_151934.png" alt="Dart" height="20" style="vertical-align: middle; filter: none;"/>
  <img src="https://firebase.google.com/static/downloads/brand-guidelines/SVG/logo-standard.svg" alt="Firebase" height="20" style="vertical-align: middle; filter: none;"/>
  
  </h2>
 
  
  Flutter: Flutter is Google's UI toolkit for building natively compiled apps for various platforms.

  
  Dart: Dart is a fast, modern programming language primarily used in Flutter development.

  
  Firebase: Firebase is Google's mobile and web app development platform with a wide range of tools and services.
  
  
</section>


<section id="screenshots">
  <h2> Screenshots </h2>
  <h3> Landing Page: </h3>   
  <img src="https://github.com/user-attachments/assets/94550299-4ffd-425a-b8c0-351cf29e965f" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/dba81fb3-8a1b-411a-8302-3d54097f34ca" width="200" style="max-width: 100%;">
  <br>
  <h3> Teachers Version: </h3> 
  <img src="https://github.com/user-attachments/assets/a2d17bae-7cfa-4141-b9be-0bfdc9710a39" alt="Screenshot 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/b3269cb3-8f1f-4a17-bc70-3a7396baaf17" alt="Screenshot 2" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/41f4946d-4e4d-4f8c-ac5c-f66f48c19d9c" alt="Image 2" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/7bbf25e6-6d0d-48db-ba74-74bf7de1e481" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/cd40dc69-2145-42aa-a0e2-5e3608f8b072" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/e8962dd0-111c-4166-9563-34960a356120" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/0287b726-3a43-4005-b9bb-8b894811b420" alt="Image 1" width="400" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/595e38c0-d742-4db2-994a-65ef705d2aab" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/3e6905f2-d99c-4995-b6b1-4a2d801c42fc" alt="Image 1" width="200" style="max-width: 100%;">
  


  
  <h3> Students Version: </h3>
  <img src="https://github.com/user-attachments/assets/4ffbabbb-dd7f-4c12-aaf1-38e2dbd2620a" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/6f2f90f1-192f-4d48-818a-f81084593ff6" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/5c64be3e-ee95-4db8-8c00-ffceac434978" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/eb661c72-e198-4a38-a6d8-adf8d44ef07e" alt="Image 1" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/b3269cb3-8f1f-4a17-bc70-3a7396baaf17" alt="Screenshot 2" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/efc9de2a-6834-4918-bae1-ed679f367dbb" alt="Screenshot 2" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/e7998cf6-a5d1-49cb-be13-2822c708604e" alt="Screenshot 2" width="200" style="max-width: 100%;">
  <img src="https://github.com/user-attachments/assets/91922491-e259-4578-8121-82a42ecdfc9f" alt="Screenshot 2" width="200" style="max-width: 100%;">

 </section>

  
<section id="Attendance Process">
  <h2> Attendance Process </h2>

  <h3>Teacher Version</h3>

  [![Watch the video](https://via.placeholder.com/150)](https://github.com/user-attachments/assets/7779b834-46de-4a3e-a55d-9ca72d8411ce)

<h3>Student Version</h3>

  [![Watch the video](https://via.placeholder.com/150)](https://github.com/user-attachments/assets/716a009c-b173-49c1-8c2b-00d714babfef)

</section>
<section id = "team">
  <h2> The Team </h2>
  <h3> Pannaga R Bhat </h3>
<p align="left">
  <a href="https://github.com/pannaga-rj" style="text-decoration: none;" target="_blank" rel="nofollow">
    <img src="https://img.shields.io/badge/GitHub-black?style=flat&logo=github" alt="GitHub" style="max-width: 100%;">
  </a>
  <a href="www.linkedin.com/in/pannaga-r-bhat-ba8bb6289" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin" alt="LinkedIn" />
  </a>
</p>

<h3> Pradeep P T </h3>
<p align="left">
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-black?style=flat&logo=github" alt="GitHub" />
  </a>
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin" alt="LinkedIn" />
  </a>
</p>

<h3> Prajwal P </h3>
<p align="left">
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-black?style=flat&logo=github" alt="GitHub" />
  </a>
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin" alt="LinkedIn" />
  </a>
</p>

<h3> Pranav Anantha Rao </h3>
<p align="left">
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-black?style=flat&logo=github" alt="GitHub" />
  </a>
  <a href="" style="text-decoration: none;" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin" alt="LinkedIn" />
  </a>
</p>
</section>



