<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EdupathWebForms.Pages.Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edupath - Your Path to Smarter Learning</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --accent-color: #f39c12;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
        }
        
        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 100px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        

        
        .hero h1 {
            font-weight: 700;
            font-size: 3.5rem;
            margin-bottom: 1rem;
        }
        
        .hero p.lead {
            font-size: 1.5rem;
            max-width: 700px;
            margin: 0 auto 2rem;
        }
        
        .btn-hero {
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 500;
            border-radius: 50px;
            margin: 0 10px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: white;
            color: var(--primary-color);
            border: 2px solid white;
        }
        
        .btn-outline-light {
            border: 2px solid white;
        }
        
        .btn-primary:hover {
            background-color: transparent;
            color: white;
        }
        
        /* Features Section */
        .features {
            padding: 80px 0;
            background-color: var(--light-color);
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .section-title h2 {
            font-weight: 700;
            color: var(--dark-color);
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }
        
        .section-title h2::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: var(--primary-color);
        }
        
        .feature-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            text-align: center;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        
        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .feature-card h3 {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--dark-color);
        }
        
        /* Testimonials */
        .testimonials {
            padding: 80px 0;
            background-color: white;
        }
        
        .testimonial-card {
            background: var(--light-color);
            border-radius: 10px;
            padding: 30px;
            margin: 15px;
        }
        
        /* Call to Action */
        .cta {
            background: var(--dark-color);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .cta h2 {
            font-weight: 700;
            margin-bottom: 30px;
        }
        
        /* Footer */
        .footer {
            background: var(--dark-color);
            color: white;
            padding: 30px 0;
            text-align: center;
        }
        
        .social-icons {
            margin: 20px 0;
        }
        
        .social-icons a {
            color: white;
            font-size: 1.5rem;
            margin: 0 10px;
            transition: color 0.3s ease;
        }
        
        .social-icons a:hover {
            color: var(--accent-color);
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.5rem;
            }
            
            .hero p.lead {
                font-size: 1.2rem;
            }
            
            .btn-hero {
                display: block;
                width: 80%;
                margin: 10px auto;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <h1 class="display-3">🎓 Edupath</h1>
                <p class="lead">Your Path to Smarter Learning</p>
                <div class="mt-4">
                    <a href="Login.aspx" class="btn btn-hero btn-primary">Log In</a>
                    <a href="Register.aspx" class="btn btn-hero btn-outline-light">Register</a>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features">
            <div class="container">
                <div class="section-title">
                    <h2>Why Choose Edupath?</h2>
                </div>
                <div class="row">
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <h3>Class Management</h3>
                            <p>Create and manage your virtual classrooms with our intuitive interface designed for educators and students alike.</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <h3>Assignments</h3>
                            <p>Upload, submit and grade assignments with our streamlined workflow that saves time and reduces paperwork.</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <h3>Interactive Quizzes</h3>
                            <p>Engage students with our interactive quiz system that provides instant feedback and performance analytics.</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <h3>Teacher Dashboard</h3>
                            <p>Comprehensive overview of your classes with real-time analytics to track student progress and engagement.</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-cogs"></i>
                            </div>
                            <h3>Admin Panel</h3>
                            <p>Powerful tools to manage users, courses, and system settings with granular control and permissions.</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-comments"></i>
                            </div>
                            <h3>Class Discussions</h3>
                            <p>Foster collaboration and engagement through our integrated class forums and discussion boards.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="testimonials">
            <div class="container">
                <div class="section-title">
                    <h2>What Our Users Say</h2>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="testimonial-card">
                            <p>"Edupath has transformed how I manage my classes. The assignment system saves me hours each week!"</p>
                            <div class="author">
                                <strong>- Sarah Johnson</strong>
                                <p>High School Teacher</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="testimonial-card">
                            <p>"As a student, I love how easy it is to submit assignments and get feedback from my teachers."</p>
                            <div class="author">
                                <strong>- Michael Chen</strong>
                                <p>College Student</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="testimonial-card">
                            <p>"The admin tools give me complete control over our school's digital learning environment."</p>
                            <div class="author">
                                <strong>- David Wilson</strong>
                                <p>School Administrator</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Call to Action -->
        <section class="cta">
            <div class="container">
                <h2>Ready to Transform Your Learning Experience?</h2>
                <a href="Register.aspx" class="btn btn-hero btn-primary">Get Started Now</a>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="social-icons">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin"></i></a>
                </div>
                <p>&copy; 2025 Edupath. All rights reserved.</p>
            </div>
        </footer>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>